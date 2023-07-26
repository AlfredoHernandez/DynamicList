//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

#if DEBUG

import SwiftUI

struct AdvertisementView: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "applelogo")
            Text(text)
        }
        .padding()
        .foregroundColor(.red)
        .background(
            Rectangle()
                .fill(.black)
                .cornerRadius(8)
        )
        .frame(maxWidth: .infinity)
        .onTapGesture {
            print("Handle tap...")
        }
    }
}

struct AdvertisementView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertisementView(
            text: "Advertisment: Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        )
    }
}

#endif
