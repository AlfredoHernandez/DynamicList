//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public class FeedViewStore<Item>: ObservableObject {
    @Published var items: [Item]
    @Published var topicSelected: String = ""
    @Published public private(set) var isLoading = false
    private let loader: () -> AnyPublisher<[Item], Error>
    private var cancellables = Set<AnyCancellable>()

    public let topics: [Topic<Item>]
    public let generateRandomItemsForLoading: (() -> [Item])?

    public init(
        items: [Item] = [],
        topics: [Topic<Item>],
        generateRandomItemsForLoading: (() -> [Item])?,
        loader: @escaping () -> AnyPublisher<[Item], Error>
    ) {
        self.items = items
        self.topics = topics
        self.generateRandomItemsForLoading = generateRandomItemsForLoading
        self.loader = loader

        if let firstTopic = topics.first {
            topicSelected = firstTopic.name
        }
    }

    public func loadItems() {
        isLoading = true
        loader()
            .handleEvents(receiveRequest: { [weak self] _ in
                guard let self, let randomItemsGenerator = generateRandomItemsForLoading else { return }
                if items.count == 0 { items = randomItemsGenerator() }
            })
            .tryMap { items in
                let index = self.topics.firstIndex(where: { $0.name == self.topicSelected }) ?? 0
                let predicate = self.topics[index].predicate
                return try items.filter(predicate)
            }
            .sink { completion in
                switch completion {
                case .failure:
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] feed in
                withAnimation {
                    self?.items = feed
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
