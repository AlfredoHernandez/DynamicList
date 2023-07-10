//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

#if DEBUG

import SwiftUI

struct FruitItemView: View {
    let item: Fruit

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .bold()
                    .font(.title3)
                    .foregroundColor(.black)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            Text(item.symbol)
        }.frame(maxWidth: .infinity)
    }
}

struct FruitItemView_Previews: PreviewProvider {
    static var previews: some View {
        FruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
            .previewLayout(.fixed(width: 340, height: 60))
    }
}

#endif
