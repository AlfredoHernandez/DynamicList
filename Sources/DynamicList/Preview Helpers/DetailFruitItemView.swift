//
//  Copyright © 2024 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

#if DEBUG

import SwiftUI

struct DetailFruitItemView: View {
    let item: Fruit

    var body: some View {
        VStack(spacing: 16) {
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            )
            VStack {
                Text("FRUIT SYMBOL")
                    .bold()
                Text(item.symbol)
                    .font(.system(size: 256))
            }
            Spacer()
        }
        .padding()
        .navigationTitle(item.name)
    }
}

struct DetailPreviewFruitItemView: View {
    let item: Fruit

    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text(item.symbol)
                    .font(.system(size: 64))
            }
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            )
        }
        .frame(width: 340, height: 100)
    }
}

struct DetailFruitItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailFruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
            
            DetailPreviewFruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
        }
    }
}

#endif
