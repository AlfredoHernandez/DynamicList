//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

public struct DynamicListConfig {
    public let topicsToolbarPlacement: ToolbarItemPlacement
    public let listStyle: DynamicListStyle
    public let hideRowSeparator: Bool
    public let withScrollButton: Bool
    public let paddingBottom: CGFloat

    public init(
        topicsToolbarPlacement: ToolbarItemPlacement = .principal,
        listStyle: DynamicListStyle = .plain,
        hideRowSeparator: Bool = false,
        withScrollButton: Bool = true,
        paddingBottom: CGFloat = 0.0
    ) {
        self.topicsToolbarPlacement = topicsToolbarPlacement
        self.listStyle = listStyle
        self.hideRowSeparator = hideRowSeparator
        self.withScrollButton = withScrollButton
        self.paddingBottom = paddingBottom
    }
}

public extension DynamicListConfig {
    static let `default` = DynamicListConfig()
}
