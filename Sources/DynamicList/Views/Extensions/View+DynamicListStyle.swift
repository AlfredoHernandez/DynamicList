//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func dynamicListStyle(type: DynamicListStyle) -> some View {
        switch type {
        case .plain:
            listStyle(.plain)
        case .inset:
            listStyle(.inset)
        case .sidebar:
            listStyle(.sidebar)
        case .automatic:
            listStyle(.automatic)
        #if os(iOS)
        case .grouped:
            listStyle(.grouped)
        case .insetGrouped:
            listStyle(.insetGrouped)
        #elseif os(macOS)
        case .insetGrouped, .grouped:
            listStyle(.automatic)
        #endif
        }
    }
    
    @ViewBuilder
    func navigationViewStyleColumn() -> some View {
        if #available(iOS 15.0, *) {
            navigationViewStyle(.columns)
        } else {
            self
        }
    }
}
