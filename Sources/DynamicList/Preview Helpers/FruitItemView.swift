//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

#if DEBUG

import SwiftUI

struct FruitItemView: View {
    let item: Fruit

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .shadow(radius: 4)
                    .foregroundColor(item.color.toColor())
                Text(item.symbol)
                    .font(.system(size: 48))
            }.frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .bold()
                    .font(.title3)
                    .foregroundColor(.black)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension FruitColor {
    func toColor() -> Color {
        switch self {
        case FruitColor.green:
            return Color.green
        case FruitColor.orange:
            return Color.orange
        case FruitColor.purple:
            return Color.purple
        case FruitColor.red:
            return Color.red
        case FruitColor.yellow:
            return Color.yellow
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
