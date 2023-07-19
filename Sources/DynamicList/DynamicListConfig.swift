//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

public struct DynamicListConfig {
    public let topicsToolbarPlacement: ToolbarItemPlacement
    public let listStyle: DynamicListStyle
    public let hideRowSeparator: Bool

    public init(topicsToolbarPlacement: ToolbarItemPlacement = .principal, listStyle: DynamicListStyle = .plain, hideRowSeparator: Bool = false) {
        self.topicsToolbarPlacement = topicsToolbarPlacement
        self.listStyle = listStyle
        self.hideRowSeparator = hideRowSeparator
    }
}
