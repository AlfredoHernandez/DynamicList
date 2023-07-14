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
}
