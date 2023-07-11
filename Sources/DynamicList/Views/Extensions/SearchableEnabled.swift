//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

extension View {
    func searchableEnabled(text: Binding<String>, prompt: Text?, display: Bool) -> some View {
        display ? AnyView(searchableIfAvalable(text: text, prompt: prompt)) : AnyView(self)
    }

    private func searchableIfAvalable(text: Binding<String>, prompt: Text?) -> some View {
        if #available(iOS 15.0, *) {
            return searchable(text: text, prompt: prompt)
        } else {
            return self
        }
    }
}
