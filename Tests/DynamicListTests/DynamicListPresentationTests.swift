//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import DynamicList
import XCTest

final class DynamicListPresentationTests: XCTestCase {
    func test_search_isLocalized() throws {
        XCTAssertEqual(DynamicListPresenter.search, localized("search"))
    }

    func test_data_not_available_isLocalized() throws {
        XCTAssertEqual(DynamicListPresenter.dataNotAvailable, localized("data_not_available"))
    }

    func test_topics_isLocalized() throws {
        XCTAssertEqual(DynamicListPresenter.topics, localized("topics"))
    }

    func test_networkError_isLocalized() throws {
        XCTAssertEqual(DynamicListPresenter.networkError, localized("network_error"))
    }

    func test_loadingContent_isLocalized() throws {
        XCTAssertEqual(DynamicListPresenter.loadingContent, localized("loading_content"))
    }

    func test_newsFeedConnectivityErrorRefresh_isLocalized() {
        XCTAssertEqual(DynamicListPresenter.connectivityErrorRefresh, localized("connectivity_error_refresh"))
    }

    // MARK: - Test helpers

    private func localized(_ key: String, param: CVarArg? = nil, table: String = "Localizable", file: StaticString = #filePath, line: UInt = #line) -> String {
        let bundle = Bundle.module
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: `\(key)` in table: `\(table)`", file: file, line: line)
        }
        if let param { return String(format: value, param) }
        return value
    }
}
