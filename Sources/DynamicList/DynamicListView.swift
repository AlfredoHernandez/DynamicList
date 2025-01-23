//
//  Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import AlertToast
import Combine
import SwiftUI

public struct DynamicListView<Item: Identifiable & Hashable>: View {
    @State var store: DynamicListViewStore<Item>

    public var sections: Int {
        store.sections.count
    }

    public func items(in section: Int) -> [Item] {
        store.sections[section].items
    }

    let listItemView: (Item) -> AnyView
    let noItemsView: () -> any View
    let errorView: () -> any View
    let config: DynamicListConfig

    init(
        store: DynamicListViewStore<Item>,
        listItemView: @escaping (Item) -> AnyView,
        noItemsView: @escaping () -> any View,
        errorView: @escaping () -> any View,
        config: DynamicListConfig
    ) {
        self.listItemView = listItemView
        self.store = store
        self.noItemsView = noItemsView
        self.errorView = errorView
        self.config = config
    }

    public var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ZStack {
                    List {
                        ForEach(store.sections, id: \.id) { (section: DynamicListSection) in
                            Section {
                                ForEach(section.items, id: \.id) { (item: Item) in
                                    listItemView(item)
                                        .hideRowSeparator(config.list.hideRowSeparator)
                                        .redacted(reason: store.isLoading ? .placeholder : [])
                                        .disabled(store.isLoading)
                                        .id(item.id)
                                }
                            } header: {
                                AnyView(section.header)
                            } footer: {
                                AnyView(section.footer)
                            }
                        }
                    }
                    .refreshableIfAvailable {
                        await store.loadItemsAsync()
                    }
                    .searchableEnabled(
                        text: $store.query,
                        prompt: Text(DynamicListPresenter.search),
                        display: store.searchingByQuery != nil
                    )
                    .overlay(Group {
                        if let items = store.sections.first?.items, items.isEmpty, store.error == nil {
                            withAnimation(.easeIn) {
                                AnyView(noItemsView())
                            }
                        } else if let _ = store.error {
                            withAnimation {
                                AnyView(errorView())
                            }
                        }
                    })
                    .dynamicListStyle(type: config.list.style)

                    FloatingActionButtonView(paddingBottom: config.fab.paddingBottom) {
                        scrollToTop(using: proxy)
                    }
                    .hiddenIf(!config.fab.enabled)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: config.topics.toolbarPlacement) {
                TopicSegmentedView(
                    topicSelected: $store.topicSelected,
                    topics: store.topics.map(\.name)
                )
            }
        })
        #if os(iOS)
        .navigationViewStyleColumn()
        #endif
        .onAppear(perform: loadFirstTime)
        .onAppear(perform: config.lifecycle.onAppear)
        .onChange(of: store.topicSelected, loadItems)
        .toast(isPresenting: $store.showLoadingAlert, duration: .infinity, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: DynamicListPresenter.loadingContent)
        }
        .toast(isPresenting: $store.displayingError, duration: 5.0, tapToDismiss: true) {
            AlertToast(displayMode: .hud, type: .error(.red), title: DynamicListPresenter.connectivityErrorRefresh)
        }
    }

    public func loadItems() {
        Task { await store.loadItemsAsync() }
    }

    private func loadFirstTime() {
        Task { await store.loadFirstTime() }
    }

    private func scrollToTop(using proxy: ScrollViewProxy) {
        withAnimation {
            let firstItemID = store.sections.first?.items.first?.id
            proxy.scrollTo(firstItemID)
        }
    }
}

#Preview("Simple list") {
    NavigationStack {
        DynamicListViewComposer.compose(
            sections: DynamicListSection<AnyIdentifiable>.build(2),
            loader: testFruitsLoader,
            itemFeedView: { item in
                if let fruit = item.value as? Fruit {
                    return NavigationLink(value: fruit) {
                        FruitItemView(item: fruit)
                    }
                } else if let ad = item.value as? Advertisment {
                    return AdvertisementView(text: ad.text)
                }
                return EmptyView()
            }, config: DynamicListConfig(
                list: ListConfig(style: .grouped)
            )
        )
        .navigationDestination(for: Fruit.self, destination: { fruit in
            DetailFruitItemView(item: fruit)
        })
        .navigationTitle("My fruit list")
    }
}

#Preview("Complex List") {
    NavigationStack {
        DynamicListViewComposer.compose(
            sections: [
                firstItemsSection,
                secondItemsSection,
            ],
            loader: testFruitsLoader,
            topics: filters,
            searchingByQuery: searchingByQuery(query:item:),
            generateRandomItemsForLoading: randomItemsGenerator,
            itemFeedView: { item in
                if let fruit = item.value as? Fruit {
                    return NavigationLink(value: fruit) {
                        FruitItemView(item: fruit)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        #if os(iOS)
                        return RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                            .foregroundColor(Color(uiColor: UIColor.tertiarySystemBackground))
                            .shadow(radius: 2, x: 0, y: 0)
                        #elseif os(macOS)
                        return RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                            .shadow(radius: 2, x: 0, y: 0)
                        #endif
                    }
                } else if let ad = item.value as? Advertisment {
                    return AdvertisementView(text: ad.text)
                }
                return EmptyView()
            },
            noItemsView: {
                NoItemsView(icon: "newspaper")
            },
            errorView: {
                LoadingErrorView(icon: "x.circle")
            },
            config: DynamicListConfig(
                topics: TopicsConfig(),
                list: ListConfig(style: .inset),
                fab: FabConfig(),
                lifecycle: Lifecycle(onAppear: addMoreItemsForTesting)
            )
        )
        .navigationDestination(for: Fruit.self, destination: { fruit in
            DetailFruitItemView(item: fruit)
        })
        .navigationTitle("My fruit list")
    }
}
