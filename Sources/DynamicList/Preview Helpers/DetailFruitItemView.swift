//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
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

struct DetailFruitItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailFruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
            .previewLayout(.fixed(width: 340, height: 60))
    }
}

#endif
