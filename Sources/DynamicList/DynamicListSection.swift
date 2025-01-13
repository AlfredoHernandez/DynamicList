//
// Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
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
