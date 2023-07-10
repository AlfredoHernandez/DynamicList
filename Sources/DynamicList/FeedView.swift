//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public struct FeedView<Item: Identifiable>: View {
    @ObservedObject public var store: FeedViewStore<Item>
    public let itemFeedView: (Item) -> AnyView
    public let title: String

    public init(store: FeedViewStore<Item>, itemFeedView: @escaping (Item) -> AnyView, title: String) {
        self.store = store
        self.itemFeedView = itemFeedView
        self.title = title
    }

    public var body: some View {
        NavigationView {
            VStack {
                List(store.items, id: \.id) { item in
                    itemFeedView(item)
                }
                .redacted(reason: store.isLoading ? .placeholder : [])
                .listStyle(.plain)
            }
            .navigationTitle(title)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    TopicSegmentedView(
                        topicSelected: $store.topicSelected,
                        topics: store.topics.map(\.name)
                    )
                }
            })
        }
        .onAppear(perform: store.loadItems)
        .onChange(of: store.topicSelected, perform: { _ in
            store.loadItems()
        })
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView<Fruit>(
            store: FeedViewStore<Fruit>(
                topics: filters,
                generateRandomItemsForLoading: randomItemsGenerator,
                loader: { fruitsLoader }
            ),
            itemFeedView: { fruit in
                AnyView(FruitItemView(item: fruit))
            },
            title: "News Feed"
        )
    }
}
