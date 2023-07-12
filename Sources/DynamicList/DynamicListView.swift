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
                List(store.items, id: \.id) {
                    listItemView($0)
                }
                .refreshableIfAvailable {
                    await store.loadItemsAsync()
                }
                .redacted(reason: store.isLoading ? .placeholder : [])
                .searchableEnabled(
                    text: $store.query,
                    prompt: Text(DynamicListPresenter.search),
                    display: store.searchingByQuery != nil
                )
                .onChange(of: store.query, perform: { _ in
                    loadItems()
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
                ToolbarItem(placement: config.topicsToolbarPlacement) {
                    TopicSegmentedView(
                        topicSelected: $store.topicSelected,
                        topics: store.topics.map(\.name)
                    )
                }
            })
        }
        .onAppear {
            Task {
                await store.loadFirstTime()
            }
        }
        .onChange(of: store.topicSelected, perform: { _ in
            loadItems()
        })
    }

    private func loadItems() {
        Task {
            await store.loadItemsAsync()
        }
    }
}

struct DynamicListView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicListViewComposer.compose(
            title: "My fruit list",
            loader: fruitsLoader.delay(for: .seconds(0.6), scheduler: DispatchQueue.main).eraseToAnyPublisher,
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
            },
            config: DynamicListConfig(topicsToolbarPlacement: .principal)
        ).onAppear {
            addMoreItemsForTesting()
        }
    }
}
