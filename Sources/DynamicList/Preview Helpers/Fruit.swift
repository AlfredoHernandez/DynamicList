//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

#if DEBUG
enum FruitColor {
    case red
    case yellow
    case green
    case orange
}

struct Fruit: Identifiable {
    var id: UUID = .init()
    let name: String
    let symbol: String
    let color: FruitColor
}

let fruitsLoader = Just<[Fruit]>([
    Fruit(name: "Sandía", symbol: "🍉", color: .red),
    Fruit(name: "Pera", symbol: "🍐", color: .green),
    Fruit(name: "Manzana", symbol: "🍎", color: .red),
    Fruit(name: "Naranja", symbol: "🍊", color: .orange),
    Fruit(name: "Plátano", symbol: "🍌", color: .yellow),
])
.delay(for: .seconds(0.6), scheduler: DispatchQueue.main)
.setFailureType(to: Error.self)
.eraseToAnyPublisher()

let filters: [Topic] = [
    Topic(name: "All", predicate: { _ in true }),
    Topic(name: "Yellow", predicate: { (item: Fruit) in item.color == .yellow }),
    Topic(name: "Red", predicate: { (item: Fruit) in item.color == .red }),
]

func randomItemsGenerator() -> [Fruit] {
    [
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
        Fruit(name: "Sandía", symbol: "🍉", color: .red),
    ]
}

#endif
