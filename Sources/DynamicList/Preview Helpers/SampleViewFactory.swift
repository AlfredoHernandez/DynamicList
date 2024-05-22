//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

func sampleViewFactory(route: Route<some Identifiable & Hashable>) -> any View {
    switch route {
    case let .detail(item):
        switch item as? AnyIdentifiable {
        case let .some(item):
            switch item.value {
            case is Fruit:
                DetailFruitItemView(item: item.value as! Fruit)
            default:
                Text("Unknown any identifiable item: \(item)")
                    .bold()
            }

        default:
            Text("Unknown view: \(route)")
                .bold()
        }
    }
}
