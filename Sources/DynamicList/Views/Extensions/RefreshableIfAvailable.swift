//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

extension View {
    func refreshableIfAvailable(_ action: @Sendable @escaping () async -> Void) -> some View {
        if #available(iOS 15.0, *) {
            return refreshable(action: action)
        } else {
            return self
        }
    }
}
