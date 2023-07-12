//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import DynamicList
import Combine
import XCTest

final class DynamicListViewStoreTests: XCTestCase {
    func test_init_doesNotLoadItemsUponCreation() {
        let loader = LoaderSpy<String>()
        let _ = DynamicListViewStore<String>(loader: loader.publisher)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_loadFirstTime_requestLoadItems() async {
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(loader: loader.publisher)

        await sut.loadFirstTime {
            loader.complete(with: ["any"], at: 0)
        }
        XCTAssertEqual(loader.loadCallCount, 1)

        await sut.loadFirstTime {
            loader.complete(with: ["any"], at: 1)
        }
        XCTAssertEqual(loader.loadCallCount, 1)
    }

    func test_loadItemsAsync_displaysLoadingIndicator() async {
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(loader: loader.publisher)

        await sut.loadItemsAsync {
            XCTAssertTrue(sut.isLoading)
            loader.complete(with: ["any"], at: 0)
        }

        XCTAssertFalse(sut.isLoading)
    }

    func test_loadItemsAsync_displaysCorrectIndicatorsOnLoadingCompletions() async {
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(loader: loader.publisher)

        await sut.loadItemsAsync {
            XCTAssertNil(sut.error)
            loader.complete(with: anyNSError(), at: 0)
        }
        XCTAssertEqual(sut.error! as NSError, anyNSError())

        await sut.loadItemsAsync {
            XCTAssertNil(sut.error)
            loader.complete(with: ["a", "b", "c"], at: 1)
        }
        XCTAssertEqual(sut.items, ["a", "b", "c"])
        XCTAssertNil(sut.error)
    }

    func test_doesNotDisplayLoadingItems_ifDisabled() async {
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(
            generateRandomItemsForLoading: nil,
            loader: loader.publisher
        )

        await sut.loadItemsAsync {
            XCTAssertEqual(sut.items.count, 0)
            loader.complete(with: anyNSError(), at: 0)
        }
    }

    func test_displayingLoadingItems_ifEnabled() async {
        let randomItems = ["any", "random", "items"]
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(
            generateRandomItemsForLoading: { randomItems },
            loader: loader.publisher
        )

        await sut.loadItemsAsync {
            XCTAssertEqual(sut.items.count, randomItems.count)
            loader.complete(with: anyNSError(), at: 0)
        }
    }

    func test_doesNotFilterItemsByTopic_whenTopicsAreEmpty() async {
        let items = ["any", "random", "items"]
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(
            topics: [],
            loader: loader.publisher
        )

        await sut.loadItemsAsync {
            loader.complete(with: items, at: 0)
        }

        XCTAssertEqual(sut.items, items)
    }

    func test_filtersItemsByTopic_whenTopicsAreNotEmpty() async {
        let topicSelectedName = "Filter by size of 4"
        let items = ["abcd", "dcba", "ab", "abba", "bb"]
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(
            topics: [
                Topic(name: topicSelectedName, predicate: { item in
                    item.count == 4
                }),
            ],
            loader: loader.publisher
        )

        sut.topicSelected = topicSelectedName
        await sut.loadItemsAsync {
            loader.complete(with: items, at: 0)
        }

        XCTAssertEqual(sut.items, ["abcd", "dcba", "abba"])
    }

    func test_searchByQuery_returnsItemsSearchingByQuery() async {
        let items = ["home", "office", "test", "todo", "fix"]
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(
            searchingByQuery: { query, item in
                query == "" ? true : item.range(of: query, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            },
            loader: loader.publisher
        )

        sut.query = "o"
        await sut.loadItemsAsync {
            loader.complete(with: items, at: 0)
        }

        XCTAssertEqual(sut.items, ["home", "office", "todo"])
    }

    func test_searchByQuery_returnsAllItemsIfDisabled() async {
        let items = ["home", "office", "test", "todo", "fix"]
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(
            searchingByQuery: nil,
            loader: loader.publisher
        )

        sut.query = "any query"
        await sut.loadItemsAsync {
            loader.complete(with: items, at: 0)
        }

        XCTAssertEqual(sut.items, items)
    }
}
