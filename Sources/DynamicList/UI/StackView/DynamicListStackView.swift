//
//  Created by Jesús Alfredo Hernández Alarcón on 21/05/24.
//

import SwiftUI
import AlertToast

@available(iOS 16.0, *)
public struct DynamicListStackView<Item: Identifiable & Hashable>: View {
    @StateObject var routerManager = NavigationRouter<Item>()
    @ObservedObject var store: DynamicListViewStore<Item>

    private let title: String
    private let listItemView: (Item) -> any View
    private let viewFactory: (Route<Item>) -> any View
    private let noItemsView: () -> any View
    private let errorView: () -> any View
    private let config: DynamicListConfig

    init(
        title: String,
        store: DynamicListViewStore<Item>,
        listItemView: @escaping (Item) -> any View,
        @ViewBuilder viewFactory: @escaping (Route<Item>) -> any View,
        noItemsView: @escaping () -> any View,
        errorView: @escaping () -> any View,
        config: DynamicListConfig
    ) {
        self.title = title
        self.store = store
        self.listItemView = listItemView
        self.viewFactory = viewFactory
        self.noItemsView = noItemsView
        self.errorView = errorView
        self.config = config
    }

    public var body: some View {
        NavigationStack(path: $routerManager.routes) {
            List {
                ForEach(store.sections, id: \.id) { (section: DynamicListSection) in
                    Section {
                        ForEach(section.items, id: \.id) { (item: Item) in
                            NavigationLink(value: Route<Item>.detail(forItem: item)) {
                                AnyView(listItemView(item))
                                    .hideRowSeparator(config.list.hideRowSeparator)
                                    .redacted(reason: store.isLoading ? .placeholder : [])
                                    .disabled(store.isLoading)
                                    .id(item.id)
                            }
                        }
                    } header: {
                        AnyView(section.header)
                    } footer: {
                        AnyView(section.footer)
                    }
                }
            }
            .navigationTitle(title)
            .refreshableIfAvailable { await store.loadItemsAsync() }
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
            .toolbar(content: {
                ToolbarItem(placement: config.topics.toolbarPlacement) {
                    TopicSegmentedView(
                        topicSelected: $store.topicSelected,
                        topics: store.topics.map(\.name)
                    )
                }
            })
            .navigationDestination(for: Route<Item>.self, destination: { routePath in
                AnyView(viewFactory(routePath))
            })
            .onAppear(perform: loadFirstTime)
            .onAppear(perform: config.lifecycle.onAppear)
            .onChange(of: store.topicSelected, perform: { _ in loadItems() })
        }
        .toast(isPresenting: $store.showLoadingAlert, duration: .infinity, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: DynamicListPresenter.loadingContent)
        }
        .toast(isPresenting: $store.displayingError, duration: 5.0, tapToDismiss: true) {
            AlertToast(displayMode: .hud, type: .error(.red), title: DynamicListPresenter.connectivityErrorRefresh)
        }
    }

    private func loadFirstTime() {
        Task { await store.loadFirstTime() }
    }
    
    public func loadItems() {
        Task { await store.loadItemsAsync() }
    }
}

@available(iOS 16.0, *)
#Preview {
    DynamicListStackViewComposer.compose(
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
        viewFactory: sampleViewFactory,
        noItemsView: { NoItemsView(icon: "newspaper") },
        errorView: { LoadingErrorView(icon: "x.circle") },
        config: DynamicListConfig(
            topics: TopicsConfig(),
            list: ListConfig(style: .inset),
            fab: FabConfig(),
            lifecycle: Lifecycle(onAppear: addMoreItemsForTesting)
        )
    )
}
