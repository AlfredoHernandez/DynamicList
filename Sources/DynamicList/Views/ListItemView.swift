//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct ListItemView<Item>: View {
    let itemFeedView: () -> any View
    let detailItemView: (() -> any View)?
    let itemBackground: () -> any View

    init(
        itemFeedView: @escaping () -> any View,
        detailItemView: (() -> any View)? = nil,
        itemBackground: @escaping () -> any View = { EmptyView() }
    ) {
        self.itemFeedView = itemFeedView
        self.detailItemView = detailItemView
        self.itemBackground = itemBackground
    }

    var body: some View {
        if let detailItemView {
            if #available(iOS 15, *) {
                AnyView(itemFeedView().frame(maxWidth: .infinity, alignment: .leading))
                    .overlay {
                        NavigationLink {
                            AnyView(detailItemView())
                        } label: {
                            EmptyView()
                        }
                    }
                    .padding(8)
                    .background(
                        AnyView(itemBackground())
                    )
            } else {
                NavigationLink {
                    AnyView(detailItemView())
                } label: {
                    AnyView(itemFeedView())
                }
                .padding(8)
                .background(
                    AnyView(itemBackground())
                )
            }
        } else {
            AnyView(itemFeedView())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background(
                    AnyView(itemBackground())
                )
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static let fruitA = Fruit(name: "Plátano", symbol: "🍌", color: .yellow)
    static let fruitB = Fruit(name: "Manzana", symbol: "🍎", color: .red)
    static let fruitC = Fruit(name: "Naranja", symbol: "🍊", color: .orange)

    static var previews: some View {
        List {
            ListItemView<Fruit>(itemFeedView: { FruitItemView(item: fruitA) }, detailItemView: {
                DetailFruitItemView(item: fruitA)
            }, itemBackground: {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .foregroundColor(Color.red)
                    .shadow(radius: 2, x: 0, y: 0)
            })
            ListItemView<Fruit>(itemFeedView: { FruitItemView(item: fruitB) }, detailItemView: nil, itemBackground: {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .foregroundColor(Color.green)
                    .shadow(radius: 2, x: 0, y: 0)
            })
            ListItemView<Fruit>(itemFeedView: { FruitItemView(item: fruitC) }, detailItemView: {
                DetailFruitItemView(item: fruitC)
            })
        }
        .listStyle(.plain)
    }
}
