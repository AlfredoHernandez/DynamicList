//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public class DynamicListViewComposer {
    /**
     The Dynamic List UI Composer composes a dynamic list with any kind of items you provide. It requires a `loader` function to load the items from a source, such as URLSession.

     - Parameters:
         - title: The title for the view navigation.
         - loader: A function that returns a Combine publisher that emits an array of `Items`.
         - topics: An array of `Topic` objects used to filter the list. Leave empty to disable filtering.
         - searchingByQuery: Enables a search bar to search for items in the list. Disabled by default.
         - generateRandomItemsForLoading: A generator function to display redacted items while loading. Set to `nil` to disable.
         - itemFeedView: The view used to display an item.
         - detailItemView: The view used to display the detailed item.
         - noItemsView: The view used to display when no items are available in the list.
         - errorView: The view used to display when a network error occurs.

     Example usage of the `loader` parameter where the `Item` is a `Fruit`:
     ```
     let fruitsLoader = CurrentValueSubject<[Fruit], Error>([
         Fruit(name: "Sandía", symbol: "🍉", color: .red),
         Fruit(name: "Pera", symbol: "🍐", color: .green),
         Fruit(name: "Manzana", symbol: "🍎", color: .red),
         Fruit(name: "Naranja", symbol: "🍊", color: .orange),
         Fruit(name: "Plátano", symbol: "🍌", color: .yellow),
     ]).eraseToAnyPublisher()
     ```

     - Returns: The Dynamic List View.
     */
    public static func compose<Item>(
        title: String,
        sections: [DynamicListSection<Item>] = [DynamicListSection(id: UUID(), header: EmptyView(), items: [])],
        loader: @escaping () -> AnyPublisher<[Item], Error>,
        topics: [Topic<Item>] = [],
        searchingByQuery: ((String, Item) -> Bool)? = nil,
        generateRandomItemsForLoading: (() -> [Item])? = nil,
        itemFeedView: @escaping (Item) -> any View,
        detailItemView: ((Item) -> (any View)?)? = nil,
        itemBackground: @escaping () -> any View = { EmptyView() },
        noItemsView: @escaping () -> any View = { NoItemsView() },
        errorView: @escaping () -> any View = { LoadingErrorView() },
        config: DynamicListConfig
    ) -> DynamicListView<Item> {
        DynamicListView<Item>(
            title: title,
            listItemView: { item in
                guard let detailedItemView = detailItemView?(item) else {
                    return ListItemView<Item>(itemFeedView: { itemFeedView(item) }, detailItemView: nil, itemBackground: itemBackground)
                }
                return ListItemView<Item>(itemFeedView: { itemFeedView(item) }, detailItemView: { detailedItemView }, itemBackground: itemBackground)
            },
            store: DynamicListViewStore<Item>(
                sections: sections,
                topics: topics,
                searchingByQuery: searchingByQuery,
                generateRandomItemsForLoading: generateRandomItemsForLoading,
                loader: loader
            ),
            noItemsView: noItemsView,
            errorView: errorView,
            config: config
        )
    }
}
