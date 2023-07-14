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
        #if os(iOS)
        case .grouped:
            listStyle(.grouped)
        #endif
        case .inset:
            listStyle(.inset)
        #if os(iOS)
        case .insetGrouped:
            listStyle(.insetGrouped)
        #endif
        case .sidebar:
            listStyle(.sidebar)
        case .insetGrouped, .grouped:
            listStyle(.automatic)
        }
    }
}
