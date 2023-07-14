//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public struct DynamicListView<Item: Identifiable>: View {
    @ObservedObject var store: DynamicListViewStore<Item>

    let title: String
    let listItemView: (Item) -> ListItemView<Item>
    let noItemsView: () -> any View
    let errorView: () -> any View
    let config: DynamicListConfig

    init(
        title: String,
        listItemView: @escaping (Item) -> ListItemView<Item>,
        store: DynamicListViewStore<Item>,
        noItemsView: @escaping () -> any View,
        errorView: @escaping () -> any View,
        config: DynamicListConfig
    ) {
        self.title = title
        self.listItemView = listItemView
        self.store = store
        self.noItemsView = noItemsView
        self.errorView = errorView
        self.config = config
    }

    public var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.items, id: \.id) { (section: DynamicListSection) in
                        Section(header: AnyView(section.header)) {
                            ForEach(section.items, id: \.id) { (item: Item) in
                                listItemView(item)
                                    .redacted(reason: store.isLoading ? .placeholder : [])
                            }
                        }
                    }
                }
                .refreshableIfAvailable { await store.loadItemsAsync() }
                .searchableEnabled(
                    text: $store.query,
                    prompt: Text(DynamicListPresenter.search),
                    display: store.searchingByQuery != nil
                )
                .onChange(of: store.query, perform: { _ in loadItems() })
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
                .dynamicListStyle(type: config.listStyle)
            }
            .navigationTitle(title)
            .toolbar(content: {
                ToolbarItem(placement: config.topicsToolbarPlacement) {
                    TopicSegmentedView(
                        topicSelected: $store.topicSelected,
                        topics: store.topics.map(\.name)
                    )
                }
            })
        }
        .onAppear(perform: loadFirstTime)
        .onChange(of: store.topicSelected, perform: { _ in loadItems() })
    }

    private func loadItems() {
        Task { await store.loadItemsAsync() }
    }

    private func loadFirstTime() {
        Task { await store.loadFirstTime() }
    }
}

struct DynamicListView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicListViewComposer.compose(
            title: "My fruit list",
            sections: [defaultPreviewSection],
            loader: testFruitsLoader,
            topics: filters,
            searchingByQuery: searchingByQuery(query:item:),
            generateRandomItemsForLoading: randomItemsGenerator,
            itemFeedView: { item in
                if let fruit = item.value as? Fruit {
                    return FruitItemView(item: fruit)
                } else if let ad = item.value as? Advertisment {
                    return AdvertisementView(text: ad.text)
                }
                return EmptyView()
            },
            detailItemView: { item in
                if let fruit = item.value as? Fruit {
                    return DetailFruitItemView(item: fruit)
                }
                return nil
            },
            noItemsView: { NoItemsView(icon: "newspaper") },
            errorView: { LoadingErrorView(icon: "x.circle") },
            config: DynamicListConfig(topicsToolbarPlacement: .principal, listStyle: .plain)
        ).onAppear {
            addMoreItemsForTesting()
        }
    }
}
