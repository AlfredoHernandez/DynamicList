//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public class DynamicListViewComposer {
    /** The Dynamic List UI Composer
     - Parameters:
     - title: The title for view navigation
     - loader: A function that returns a combine publisher that emits [Items]
     ~~~
      let fruitsLoader = Just<[Fruit]>([
          Fruit(name: "Sandía", symbol: "🍉", color: .red),
          Fruit(name: "Pera", symbol: "🍐", color: .green),
          Fruit(name: "Manzana", symbol: "🍎", color: .red),
          Fruit(name: "Naranja", symbol: "🍊", color: .orange),
          Fruit(name: "Plátano", symbol: "🍌", color: .yellow),
      ])
      .delay(for: .seconds(0.6), scheduler: DispatchQueue.main)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
     ~~~
     - topics: An array of `Topic` to filter the list, disabled if empty
     - searchingByQuery: Add a search bar to search items in the list, default disabled
     - generateRandomItemsForLoading: A generator function to display redacted items while loading, disabled if nil
     - itemFeedView: The view to display an item
     - detailItemView: The view to display the detailed item
     - noItemsView: The view to display when no items available in the list
     - errorView: The view to display when an network error occur
     - Returns: The Dynamic List View */
    public static func compose<Item>(
        title: String,
        loader: @escaping () -> AnyPublisher<[Item], Error>,
        topics: [Topic<Item>] = [],
        searchingByQuery: ((String, Item) -> Bool)? = nil,
        generateRandomItemsForLoading: (() -> [Item])? = nil,
        itemFeedView: @escaping (Item) -> any View,
        detailItemView: ((Item) -> any View)? = nil,
        noItemsView: @escaping () -> any View = { NoItemsView() },
        errorView: @escaping () -> any View = { LoadingErrorView() },
        config: DynamicListConfig
    ) -> DynamicListView<Item> {
        DynamicListView<Item>(
            title: title,
            listItemView: { item in
                guard let detailedItemView = detailItemView?(item) else {
                    return ListItemView<Item>(itemFeedView: { itemFeedView(item) }, detailItemView: nil)
                }
                return ListItemView<Item>(itemFeedView: { itemFeedView(item) }, detailItemView: { detailedItemView })
            },
            store: DynamicListViewStore<Item>(
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
