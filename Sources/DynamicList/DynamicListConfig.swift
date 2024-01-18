//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

public struct TopicsConfig {
    public let toolbarPlacement: ToolbarItemPlacement

    public init(toolbarPlacement: ToolbarItemPlacement = .principal) {
        self.toolbarPlacement = toolbarPlacement
    }
}

public struct ListConfig {
    public let style: DynamicListStyle
    public let hideRowSeparator: Bool

    public init(style: DynamicListStyle = .plain, hideRowSeparator: Bool = false) {
        self.style = style
        self.hideRowSeparator = hideRowSeparator
    }
}

public struct FabConfig {
    public let enabled: Bool
    public let paddingBottom: CGFloat

    public init(enabled: Bool = true, paddingBottom: CGFloat = 0.0) {
        self.enabled = enabled
        self.paddingBottom = paddingBottom
    }
}

public struct Lifecycle {
    public let onAppear: (() -> Void)?
    
    public init(onAppear: (() -> Void)? = nil) {
        self.onAppear = onAppear
    }
}

public struct DynamicListConfig {
    public let topics: TopicsConfig
    public let list: ListConfig
    public let fab: FabConfig
    public let lifecycle: Lifecycle

    public init(topics: TopicsConfig = TopicsConfig(), list: ListConfig = ListConfig(), fab: FabConfig = FabConfig(), lifecycle: Lifecycle = Lifecycle()) {
        self.topics = topics
        self.list = list
        self.fab = fab
        self.lifecycle = lifecycle
    }
}

public extension DynamicListConfig {
    static let `default` = DynamicListConfig()
}
