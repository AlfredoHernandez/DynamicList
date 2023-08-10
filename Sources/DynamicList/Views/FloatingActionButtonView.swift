//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct FloatingActionButtonView: View {
    let paddingBottom: CGFloat
    let action: () -> Void

    init(paddingBottom: CGFloat = 0, action: @escaping () -> Void) {
        self.paddingBottom = paddingBottom
        self.action = action
    }

    private let size: CGFloat = 55

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Button(action: action) {
                        Image(systemName: "chevron.up")
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                            .padding()
                            .frame(width: size, height: size)
                            .foregroundColor(.white)
                    }
                    .background(Color.accentColor)
                    .cornerRadius(size / 2)
                    .padding()
                    .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0, y: 0)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: size, height: paddingBottom)
                }
            }
        }
    }
}

#if DEBUG
struct FloatingActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButtonView(action: {})
    }
}
#endif
