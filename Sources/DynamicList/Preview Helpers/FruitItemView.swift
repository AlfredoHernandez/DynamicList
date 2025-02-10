//
//  Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

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
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
                )
                .lineLimit(2)
                .font(.callout)
                .foregroundColor(.secondary)
                Divider()
                Text(item.id.uuidString)
                    .font(.system(size: 10))
            }
        }.padding(8)
    }
}

extension FruitColor {
    func toColor() -> Color {
        switch self {
        case FruitColor.green:
            Color.green
        case FruitColor.orange:
            Color.orange
        case FruitColor.purple:
            Color.purple
        case FruitColor.red:
            Color.red
        case FruitColor.yellow:
            Color.yellow
        }
    }
}

struct FruitItemView_Previews: PreviewProvider {
    static var previews: some View {
        FruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
            .previewLayout(.fixed(width: 340, height: 60))
    }
}
