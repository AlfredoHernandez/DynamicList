//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

public struct LoadingErrorView: View {
    let message: String
    let icon: String

    public init(message: String = DynamicListPresenter.networkError, icon: String = "network.slash") {
        self.message = message
        self.icon = icon
    }

    public var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.secondary)
                .bold()
        }
    }
}

#if DEBUG
struct LoadingErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingErrorView()
    }
}
#endif
