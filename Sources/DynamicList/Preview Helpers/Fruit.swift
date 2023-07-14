//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

#if DEBUG

import Combine
import Foundation
import SwiftUI

enum FruitColor: CaseIterable {
    case red
    case yellow
    case green
    case orange
    case purple
}

struct Fruit: Identifiable {
    var id: UUID = .init()
    let name: String
    let symbol: String
    let color: FruitColor
}

struct AnyIdentifiable: Identifiable {
    let id: AnyHashable
    let value: Any

    init(_ id: some Hashable, _ value: some Any) {
        self.id = AnyHashable(id)
        self.value = value
    }
}

let fruitsLoader = CurrentValueSubject<[Fruit], Error>([
    Fruit(name: "Sandía", symbol: "🍉", color: .red),
    Fruit(name: "Pera", symbol: "🍐", color: .green),
    Fruit(name: "Manzana", symbol: "🍎", color: .red),
    Fruit(name: "Naranja", symbol: "🍊", color: .orange),
    Fruit(name: "Plátano", symbol: "🍌", color: .yellow),
])

func addMoreItemsForTesting() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        fruitsLoader.send([
            Fruit(name: "Sandía", symbol: "🍉", color: .red),
            Fruit(name: "Pera", symbol: "🍐", color: .green),
            Fruit(name: "Manzana Roja", symbol: "🍎", color: .red),
            Fruit(name: "Naranja", symbol: "🍊", color: .orange),
            Fruit(name: "Plátano", symbol: "🍌", color: .yellow),
            Fruit(name: "Uva", symbol: "🍇", color: .purple),
            Fruit(name: "Manzana Verde", symbol: "🍏", color: .green),
        ])
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
        fruitsLoader.send([
            Fruit(name: "Pera", symbol: "🍐", color: .green),
            Fruit(name: "Manzana Roja", symbol: "🍎", color: .red),
            Fruit(name: "Manzana Verde", symbol: "🍏", color: .green),
            Fruit(name: "Sandía", symbol: "🍉", color: .red),
            Fruit(name: "Naranja", symbol: "🍊", color: .orange),
            Fruit(name: "Durazno", symbol: "🍑", color: .orange),
        ])
    }
}

let filters: [Topic] = [
    Topic(name: "All", predicate: { _ in true }),
    Topic(name: "Orange", predicate: { (item: AnyIdentifiable) in
        if let fruit = (item.value as? Fruit) {
            return fruit.color == .orange
        }
        return false
    }),
    Topic(name: "Red", predicate: { (item: AnyIdentifiable) in
        if let fruit = (item.value as? Fruit) {
            return fruit.color == .red
        }
        return false
    }),
    Topic(name: "No Items", predicate: { _ in false }),
    Topic(name: "Error", predicate: { _ in throw NSError(domain: "test", code: 1) }),
]

struct Advertisment: Identifiable {
    var id: UUID = .init()
    let text: String
}

func randomItemsGenerator() -> [AnyIdentifiable] {
    var fruits: [AnyIdentifiable] = []
    for _ in 1 ... 20 {
        let fruit = AnyIdentifiable(UUID(), Fruit(name: "Lorem ipsum", symbol: "$#", color: FruitColor.allCases.randomElement()!))
        fruits.append(fruit)
    }
    return fruits
}

#endif
