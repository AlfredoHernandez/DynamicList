//
//  Copyright © 2024 Jesús Alfredo Hernández Alarcón. All rights reserved.
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
            }

        default:
            Text("Unknown view: \(route)").bold()
        }

    case let .preview(item):
        switch item as? AnyIdentifiable {
        case let .some(item):
            switch item.value {
            case is Fruit:
                DetailPreviewFruitItemView(item: item.value as! Fruit)
            default:
                Text("Unknown preview any identifiable item: \(item)")
            }

        default:
            Text("Unknown preview: \(route)").bold()
        }
    }
}

