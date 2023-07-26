//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

public struct NoItemsView: View {
    let message: String
    let icon: String

    public init(message: String = DynamicListPresenter.dataNotAvailable, icon: String = "text.bubble") {
        self.message = message
        self.icon = icon
    }

    public var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 64, height: 64)
            Text(message)
                .foregroundColor(.secondary)
                .bold()
        }
    }
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NoItemsView()
    }
}
