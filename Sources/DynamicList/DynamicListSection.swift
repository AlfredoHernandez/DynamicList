//
//  Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import SwiftUI

public struct DynamicListSection<Item>: Identifiable {
    public var id: UUID
    let header: any View
    let footer: any View
    var items: [Item]

    public init(id: UUID, header: any View = EmptyView(), footer: any View = EmptyView(), items: [Item]) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
    }
}

public extension DynamicListSection {
    /// Builds an array of `DynamicListSection` with the specified number of sections.
    ///
    /// - Parameters:
    ///   - numberOfSections: The number of sections to create. Default is 1.
    ///   - itemsBuilder: A closure that provides the items for each section.
    ///   - headerBuilder: A closure that provides the header view for each section.
    ///   - footerBuilder: A closure that provides the footer view for each section.
    /// - Returns: An array of `DynamicListSection`.
    static func build(
        _ numberOfSections: Int = 1,
        itemsBuilder: (Int) -> [Item] = { _ in [] },
        headerBuilder: (Int) -> any View = { _ in EmptyView() },
        footerBuilder: (Int) -> any View = { _ in EmptyView() }
    ) -> [DynamicListSection<Item>] {
        guard numberOfSections > 0 else { return [] }

        return (0 ..< numberOfSections).map { index in
            DynamicListSection(
                id: UUID(),
                header: headerBuilder(index),
                footer: footerBuilder(index),
                items: itemsBuilder(index)
            )
        }
    }
}
