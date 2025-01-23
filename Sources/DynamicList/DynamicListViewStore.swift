//
//  Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

@Observable
class DynamicListViewStore<Item> {
    var sections: [DynamicListSection<Item>]
    var topicSelected: String = ""
    var isLoading = false
    var showLoadingAlert = false
    var query: String = "" {
        didSet {
            queryPublisher.send(query)
        }
    }

    var displayingError = false
    private let testingMode: Bool

    private var queryPublisher: CurrentValueSubject<String, Never> = .init("")

    var error: Error?
    private var firstTime = true
    private var cancellables = Set<AnyCancellable>()

    let topics: [Topic<Item>]
    let searchingByQuery: ((String, Item) -> Bool)?
    private let generateRandomItemsForLoading: (() -> [Item])?
    private let loader: () -> AnyPublisher<[[Item]], Error>

    init(
        sections: [DynamicListSection<Item>] = [DynamicListSection(id: UUID(), items: [])],
        topics: [Topic<Item>] = [],
        searchingByQuery: ((String, Item) -> Bool)? = nil,
        generateRandomItemsForLoading: (() -> [Item])? = nil,
        loader: @escaping () -> AnyPublisher<[[Item]], Error>,
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

        queryPublisher
            .dropFirst()
            .debounceIfNotTesting(testingMode)
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
        await MainActor.run { [weak self] in
            self?.updateUIWhileLoadingItems()
        }
        await withCheckedContinuation { continuation in
            loadItems {
                if !finished {
                    finished = true
                    continuation.resume()
                }
            }
            action?()
        }
    }

    private func updateUIWhileLoadingItems() {
        isLoading = true
        showLoadingAlert = true
        displayingError = false
        error = nil

        displayingLoadingItems()
    }

    private func loadItems(didFinishLoadingItems: (() -> Void)? = nil) {
        loader()
            // TODO: Fix filtering items
            // .tryMap(filteringItems)

            // TODO: Fix search
            // .tryMap { [weak self] items in
            //    guard let self, let searchingByQuery else { return items }
            //    return items.filter { item in searchingByQuery(self.query, item) }
            // }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.insert([], at: 0)
                    self?.isLoading = false
                    self?.showLoadingAlert = false
                    self?.error = error
                    self?.displayingError = true
                    didFinishLoadingItems?()
                }
            } receiveValue: { [weak self] (sections: [[Item]]) in
                for (index, items) in sections.enumerated() {
                    self?.insert(items, at: index)
                }
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
        guard !topics.isEmpty, let index = topics.firstIndex(where: { $0.name == self.topicSelected }) else {
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
    func debounceIfNotTesting(_ testing: Bool) -> AnyPublisher<Output, Failure> {
        if !testing {
            return debounce(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .userInitiated))
                .eraseToAnyPublisher()
        }
        return eraseToAnyPublisher()
    }
}
