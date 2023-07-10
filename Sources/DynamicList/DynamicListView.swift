//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public struct DynamicListView<Item: Identifiable>: View {
    @ObservedObject public var store: DynamicListViewStore<Item>

    public let title: String
    public let itemFeedView: (Item) -> any View
    public let detailItemView: (Item) -> any View
    public let noItemsView: () -> any View

    public init(
        title: String,
        store: DynamicListViewStore<Item>,
        itemFeedView: @escaping (Item) -> any View,
        detailItemView: @escaping (Item) -> any View,
        noItemsView: @escaping () -> any View
    ) {
        self.title = title 
        self.store = store
        self.itemFeedView = itemFeedView
        self.detailItemView = detailItemView
        self.noItemsView = noItemsView
    }

    public var body: some View {
        NavigationView {
            VStack {
                List(store.items, id: \.id) { item in
                    NavigationLink {
                        AnyView(detailItemView(item))
                    } label: {
                        AnyView(itemFeedView(item))
                    }
                }
                .overlay(Group {
                    if store.items.isEmpty {
                        withAnimation(.easeIn) {
                            AnyView(noItemsView())
                        }
                    }
                })
                .redacted(reason: store.isLoading ? .placeholder : [])
                .listStyle(.plain)
            }
            .navigationTitle(title)
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    TopicSegmentedView(
                        topicSelected: $store.topicSelected,
                        topics: store.topics.map(\.name)
                    )
                }
            })
        }
        .onAppear(perform: loadItems)
        .onChange(of: store.topicSelected, perform: { _ in
            loadItems()
        })
    }

    private func loadItems() {
        withAnimation {
            store.loadItems()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicListView<Fruit>(
            title: "My fruit list",
            store: DynamicListViewStore<Fruit>(
                topics: filters,
                generateRandomItemsForLoading: randomItemsGenerator,
                loader: { fruitsLoader }
            ),
            itemFeedView: FruitItemView.init,
            detailItemView: DetailFruitItemView.init,
            noItemsView: {
                NoItemsView(icon: "newspaper")
            }
        )
    }
}
