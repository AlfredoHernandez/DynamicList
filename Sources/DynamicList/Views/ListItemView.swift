//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct ListItemView<Item>: View {
    let itemFeedView: () -> any View
    let detailItemView: (() -> any View)?

    var body: some View {
        if let detailItemView {
            NavigationLink {
                AnyView(detailItemView())
            } label: {
                AnyView(itemFeedView())
            }
        } else {
            AnyView(itemFeedView())
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static let fruit = Fruit(name: "Plátano", symbol: "🍌", color: .yellow)

    static var previews: some View {
        ListItemView<Fruit>(itemFeedView: {
            FruitItemView(item: fruit)
        }, detailItemView: {
            DetailFruitItemView(item: fruit)
        })
    }
}
