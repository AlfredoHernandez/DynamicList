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
    
    func test_loadItemsAsync_displaysErrorOnFailureLoading() async {
        let loader = LoaderSpy<String>()
        let sut = DynamicListViewStore<String>(loader: loader.publisher)

        await sut.loadItemsAsync {
            XCTAssertNil(sut.error)
            loader.complete(with: anyNSError())
        }

        XCTAssertEqual(sut.error! as NSError, anyNSError())
    }
}

func anyNSError() -> NSError {
    NSError(domain: "test", code: 1)
}
