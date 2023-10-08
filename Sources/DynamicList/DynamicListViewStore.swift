//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public struct DynamicListSection<Item>: Identifiable {
    public var id: UUID
    let header: any View
    let footer: any View
    var items: [Item]

    public init(id: UUID, header: any View = EmptyView(), footer: any View = EmptyView(), items: [Item]) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
    }
}

class DynamicListViewStore<Item>: ObservableObject {
    @Published var sections: [DynamicListSection<Item>]
    @Published var topicSelected: String = ""
    @Published var isLoading = false
    @Published var showLoadingAlert = false
    @Published var query: String = ""
    @Published var displayingError = false
    private let testingMode: Bool

    var error: Error?
    private var firstTime = true
    private var cancellables = Set<AnyCancellable>()

    let topics: [Topic<Item>]
    let searchingByQuery: ((String, Item) -> Bool)?
    private let generateRandomItemsForLoading: (() -> [Item])?
    private let loader: () -> AnyPublisher<[Item], Error>

    init(
        sections: [DynamicListSection<Item>] = [DynamicListSection(id: UUID(), items: [])],
        topics: [Topic<Item>] = [],
        searchingByQuery: ((String, Item) -> Bool)? = nil,
        generateRandomItemsForLoading: (() -> [Item])? = nil,
        loader: @escaping () -> AnyPublisher<[Item], Error>,
        testingMode: Bool = false
    ) {
        self.sections = sections
        self.topics = topics
        self.searchingByQuery = searchingByQuery
        self.generateRandomItemsForLoading = generateRandomItemsForLoading
        self.loader = loader
        self.testingMode = testingMode

        if let firstTopic = topics.first {
            topicSelected = firstTopic.name
        }
        
        $query
            .dropFirst()
            .debounceIfTesting(testingMode)
            .sink { [weak self] _ in
                self?.loadItems()
            }
            .store(in: &cancellables)
    }

    func loadFirstTime(_ action: (() -> Void)? = nil) async {
        if firstTime {
            await loadItemsAsync(action)
            firstTime = false
        }
    }

    func loadItemsAsync(_ action: (() -> Void)? = nil) async {
        var finished = false
        await withCheckedContinuation { continuation in
            loadItems() {
                if !finished {
                    finished = true
                    continuation.resume()
                }
            }
            action?()
        }
    }

    private func loadItems(didFinishLoadingItems: (() -> Void)? = nil) {
        isLoading = true
        showLoadingAlert = true
        error = nil
        displayingError = false
        loader()
            .handleEvents(receiveRequest: { [weak self] _ in
                self?.displayingLoadingItems()
            })
            .tryMap(filteringItems)
            .tryMap { [weak self] items in
                guard let self, let searchingByQuery else { return items }
                return items.filter { item in searchingByQuery(self.query, item) }
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.insert([], at: 0)
                    self?.isLoading = false
                    self?.showLoadingAlert = false
                    self?.error = error
                    self?.displayingError = true
                    didFinishLoadingItems?()
                }
            } receiveValue: { [weak self] (items: [Item]) in
                self?.insert(items, at: 0)
                withAnimation(.default) {
                    self?.isLoading = false
                    self?.showLoadingAlert = false
                }
                didFinishLoadingItems?()
            }
            .store(in: &cancellables)
    }

    private func displayingLoadingItems() {
        guard let randomItemsGenerator = generateRandomItemsForLoading else { return }
        insert(randomItemsGenerator(), at: 0)
    }

    private func filteringItems(_ items: [Item]) throws -> [Item] {
        guard topics.count > 0, let index = topics.firstIndex(where: { $0.name == self.topicSelected }) else {
            return items
        }
        let predicate = topics[index].predicate
        return try items.filter(predicate)
    }

    private func insert(_ items: [Item], at section: Int = 0) {
        guard section >= 0, section < sections.count else { return }
        var selectedSectionCopy = sections[section]
        selectedSectionCopy.items = items
        sections.remove(at: section)
        sections.insert(selectedSectionCopy, at: section)
    }
}

extension Publisher {
    func debounceIfTesting(_ testing: Bool) -> AnyPublisher<Output, Failure> {
        if !testing {
            return debounce(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .userInitiated))
                .eraseToAnyPublisher()
        }
        return eraseToAnyPublisher()
    }
}
