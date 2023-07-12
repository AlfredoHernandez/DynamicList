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
        case .grouped:
            listStyle(.grouped)
        case .inset:
            listStyle(.inset)
        case .insetGrouped:
            listStyle(.insetGrouped)
        case .sidebar:
            listStyle(.sidebar)
        }
    }
}
