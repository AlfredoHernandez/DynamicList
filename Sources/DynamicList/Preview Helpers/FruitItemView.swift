//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

#if DEBUG

struct FruitItemView: View {
    let item: Fruit

    var body: some View {
        HStack {
            Text(item.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            Spacer()
            Text(item.symbol)
        }
    }
}

struct FruitItemView_Previews: PreviewProvider {
    static var previews: some View {
        FruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
            .previewLayout(.fixed(width: 340, height: 60))
    }
}

#endif
