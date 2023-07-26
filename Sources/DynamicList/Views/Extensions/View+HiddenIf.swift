//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hiddenIf(_ condition: Bool) -> some View {
        if condition {
            hidden()
                .frame(height: 0.1)
        } else { self }
    }
}
