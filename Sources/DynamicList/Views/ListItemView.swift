//
//  Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct ListItemView: View {
    let itemFeedView: () -> any View
    let itemBackground: () -> any View

    init(
        itemFeedView: @escaping () -> any View,
        itemBackground: @escaping () -> any View = { EmptyView() }
    ) {
        self.itemFeedView = itemFeedView
        self.itemBackground = itemBackground
    }

    var body: some View {
        AnyView(itemFeedView())
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AnyView(itemBackground()))
    }
}

struct ListItemView_Previews: PreviewProvider {
    static let fruitA = Fruit(name: "Plátano", symbol: "🍌", color: .yellow)
    static let fruitB = Fruit(name: "Manzana", symbol: "🍎", color: .red)
    static let fruitC = Fruit(name: "Naranja", symbol: "🍊", color: .orange)

    static var previews: some View {
        NavigationView {
            List {
                ListItemView(itemFeedView: { FruitItemView(item: fruitA) }, itemBackground: {
                    RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                        .foregroundColor(Color.red)
                        .shadow(radius: 2, x: 0, y: 0)
                })
                ListItemView(itemFeedView: { FruitItemView(item: fruitB) }, itemBackground: {
                    RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                        .foregroundColor(Color.green)
                        .shadow(radius: 2, x: 0, y: 0)
                })
                ListItemView(itemFeedView: { FruitItemView(item: fruitC) })
            }
            .listStyle(.plain)
            .navigationTitle("Example list items")
        }
    }
}
