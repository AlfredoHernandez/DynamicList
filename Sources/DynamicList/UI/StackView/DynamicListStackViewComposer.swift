//
//  Copyright © 2024 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

@available(iOS 16.0, *)
public class DynamicListStackViewComposer {
    public static func compose<Item: Identifiable & Hashable>(
        title: String,
        sections: [DynamicListSection<Item>] = [DynamicListSection(id: UUID(), header: EmptyView(), items: [])],
        loader: @escaping () -> AnyPublisher<[Item], Error>,
        topics: [Topic<Item>] = [],
        searchingByQuery: ((String, Item) -> Bool)? = nil,
        generateRandomItemsForLoading: (() -> [Item])? = nil,
        itemFeedView: @escaping (Item) -> any View,
        viewFactory: @escaping (Route<Item>) -> any View,
        itemBackground _: @escaping () -> any View = { EmptyView() },
        noItemsView: @escaping () -> any View = { NoItemsView() },
        errorView: @escaping () -> any View = { LoadingErrorView() },
        config: DynamicListConfig
    ) -> DynamicListStackView<Item> {
        DynamicListStackView<Item>(
            title: title,
            store: DynamicListViewStore<Item>(
                sections: sections,
                topics: topics,
                searchingByQuery: searchingByQuery,
                generateRandomItemsForLoading: generateRandomItemsForLoading,
                loader: loader
            ),
            listItemView: itemFeedView,
            viewFactory: viewFactory,
            noItemsView: noItemsView,
            errorView: errorView,
            config: config
        )
    }
}
