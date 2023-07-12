//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

public struct DynamicListConfig {
    public let topicsToolbarPlacement: ToolbarItemPlacement
    public let listStyle: DynamicListStyle

    public init(topicsToolbarPlacement: ToolbarItemPlacement = .principal, listStyle: DynamicListStyle = .plain) {
        self.topicsToolbarPlacement = topicsToolbarPlacement
        self.listStyle = listStyle
    }
}
