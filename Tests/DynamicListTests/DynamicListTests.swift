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
}

func anyNSError() -> NSError {
    NSError(domain: "test", code: 1)
}
