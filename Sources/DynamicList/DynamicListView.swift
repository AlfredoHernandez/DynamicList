//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public struct DynamicListView<Item: Identifiable>: View {
    @ObservedObject var store: DynamicListViewStore<Item>

    public let title: String
    public let itemFeedView: (Item) -> any View
    public let detailItemView: ((Item) -> any View)?
    public let noItemsView: () -> any View
    public let errorView: () -> any View

    init(
        title: String,
        store: DynamicListViewStore<Item>,
        itemFeedView: @escaping (Item) -> any View,
        detailItemView: ((Item) -> any View)?,
        noItemsView: @escaping () -> any View,
        errorView: @escaping () -> any View
    ) {
        self.title = title
        self.store = store
        self.itemFeedView = itemFeedView
        self.detailItemView = detailItemView
        self.noItemsView = noItemsView
        self.errorView = errorView
    }

    public var body: some View {
        NavigationView {
            VStack {
                List(store.items, id: \.id) {
                    ListItemView($0)
                }
                .redacted(reason: store.isLoading ? .placeholder : [])
                .searchableEnabled(text: $store.query, prompt: Text("Search"), display: store.searchingByQuery != nil)
                .onChange(of: store.query, perform: { _ in
                    store.loadItems()
                })
                .overlay(Group {
                    if store.items.isEmpty, store.error == nil {
                        withAnimation(.easeIn) {
                            AnyView(noItemsView())
                        }
                    } else if let _ = store.error {
                        withAnimation {
                            AnyView(errorView())
                        }
                    }
                })
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

    @ViewBuilder
    private func ListItemView(_ item: Item) -> some View {
        if let detailItemView {
            NavigationLink {
                AnyView(detailItemView(item))
            } label: {
                AnyView(itemFeedView(item))
            }
        } else {
            AnyView(itemFeedView(item))
        }
    }
}

struct DynamicListView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicListViewComposer.compose(
            title: "My fruit list",
            loader: { fruitsLoader },
            topics: filters,
            searchingByQuery: { query, fruit in
                query == "" ? true : fruit.name.range(of: query, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            },
            generateRandomItemsForLoading: randomItemsGenerator,
            itemFeedView: FruitItemView.init,
            detailItemView: DetailFruitItemView.init,
            noItemsView: {
                NoItemsView(icon: "newspaper")
            }, errorView: {
                LoadingErrorView(icon: "x.circle")
            }
        )
    }
}
