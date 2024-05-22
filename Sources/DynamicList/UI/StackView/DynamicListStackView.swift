//
//  Created by Jesús Alfredo Hernández Alarcón on 21/05/24.
//

import SwiftUI

@available(iOS 16.0, *)
public struct DynamicListStackView<Item: Identifiable & Hashable>: View {
    @StateObject var routerManager = NavigationRouter<Item>()
    @ObservedObject var store: DynamicListViewStore<Item>

    private let title: String
    private let listItemView: (Item) -> any View
    private let viewFactory: (Route<Item>) -> any View
    private let config: DynamicListConfig

    init(
        title: String,
        store: DynamicListViewStore<Item>,
        listItemView: @escaping (Item) -> any View,
        @ViewBuilder viewFactory: @escaping (Route<Item>) -> any View,
        config: DynamicListConfig
    ) {
        self.title = title
        self.store = store
        self.listItemView = listItemView
        self.viewFactory = viewFactory
        self.config = config
    }

    public var body: some View {
        NavigationStack(path: $routerManager.routes) {
            List {
                ForEach(store.sections, id: \.id) { (section: DynamicListSection) in
                    Section("Items") {
                        ForEach(section.items, id: \.id) { (item: Item) in
                            NavigationLink(value: Route<Item>.detail(forItem: item)) {
                                AnyView(listItemView(item))
                                    .hideRowSeparator(config.list.hideRowSeparator)
                                    .redacted(reason: store.isLoading ? .placeholder : [])
                                    .disabled(store.isLoading)
                                    .id(item.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationDestination(for: Route<Item>.self, destination: { routePath in
                AnyView(viewFactory(routePath))
            })
            .dynamicListStyle(type: config.list.style)
            .onAppear(perform: loadFirstTime)
        }
    }

    private func loadFirstTime() {
        Task { await store.loadFirstTime() }
    }
}

@available(iOS 16.0, *)
#Preview {
    DynamicListStackViewComposer.compose(
        title: "My fruit list",
        loader: testFruitsLoader,
        itemFeedView: { item in
            if let fruit = item.value as? Fruit {
                return FruitItemView(item: fruit)
            } else if let ad = item.value as? Advertisment {
                return AdvertisementView(text: ad.text)
            }
            return EmptyView()
        },
        viewFactory: sampleViewFactory,
        config: DynamicListConfig(
            list: ListConfig(style: .inset, hideRowSeparator: true)
        )
    )
}
