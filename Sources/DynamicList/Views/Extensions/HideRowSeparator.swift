//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder func hideRowSeparator(_ hideRowSeparator: Bool = true) -> some View {
        if hideRowSeparator {
            #if os(iOS)
            if #available(iOS 15.0, *) {
                listRowSeparator(.hidden)
            }
            #elseif os(macOS)
            if #available(macOS 13.0, *) {
                listRowSeparator(.hidden)
            }
            #endif
        } else {
            self
        }
    }
}
