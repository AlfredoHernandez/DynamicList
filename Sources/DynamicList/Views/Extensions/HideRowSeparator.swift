//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder func hideRowSeparator(_ hideRowSeparator: Bool = true) -> some View {
        if hideRowSeparator {
            if #available(iOS 15.0, *) {
                listRowSeparator(.hidden)
            }
        } else {
            self
        }
    }
}
