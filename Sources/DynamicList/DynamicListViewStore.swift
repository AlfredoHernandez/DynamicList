//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class DynamicListViewStore<Item>: ObservableObject {
    @Published var items: [Item]
    @Published var topicSelected: String = ""
    @Published public private(set) var isLoading = false
    @Published var query: String = ""

    var error: Error?
    private let loader: () -> AnyPublisher<[Item], Error>
    private var cancellables = Set<AnyCancellable>()

    public let topics: [Topic<Item>]
    public let searchingByQuery: ((String, Item) -> Bool)?
    public let generateRandomItemsForLoading: (() -> [Item])?

    init(
        items: [Item] = [],
        topics: [Topic<Item>] = [],
        searchingByQuery: ((String, Item) -> Bool)? = nil,
        generateRandomItemsForLoading: (() -> [Item])? = nil,
        loader: @escaping () -> AnyPublisher<[Item], Error>
    ) {
        self.items = items
        self.topics = topics
        self.searchingByQuery = searchingByQuery
        self.generateRandomItemsForLoading = generateRandomItemsForLoading
        self.loader = loader

        if let firstTopic = topics.first {
            topicSelected = firstTopic.name
        }
    }

    func loadItemsAsync(_ action: (() -> Void)? = nil) async {
        var finished = false
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

    private func loadItems(didFinishLoadingItems: @escaping () -> Void) {
        isLoading = true
        error = nil
        loader()
            .handleEvents(receiveRequest: { [weak self] _ in
                self?.displayingLoadingItems()
            })
            .tryMap(filteringItems)
            .tryMap { [weak self] items in
                guard let self, let searchingByQuery else { return items }
                return items.filter { item in searchingByQuery(self.query, item) }
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    self.items = []
                    self.isLoading = false
                    self.error = error
                    didFinishLoadingItems()
                }
            } receiveValue: { [weak self] feed in
                self?.items = feed
                withAnimation(.default) {
                    self?.isLoading = false
                }
                didFinishLoadingItems()
            }
            .store(in: &cancellables)
    }

    private func displayingLoadingItems() {
        guard let randomItemsGenerator = generateRandomItemsForLoading else { return }
        items = randomItemsGenerator()
    }

    private func filteringItems(_ items: [Item]) throws -> [Item] {
        guard topics.count > 0, let index = topics.firstIndex(where: { $0.name == self.topicSelected }) else {
            return items
        }
        let predicate = topics[index].predicate
        return try items.filter(predicate)
    }
}
