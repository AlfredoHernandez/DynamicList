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

let defaultPreviewSection = DynamicListSection<AnyIdentifiable>(
    id: UUID(),
    header: AdvertisementView(
        text: "You are using the free version, tap to unlock unlimited."
    ),
    items: []
)

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

func searchingByQuery(query: String, item: AnyIdentifiable) -> Bool {
    guard let fruit = (item.value as? Fruit) else { return false }
    return query == "" ? true : fruit.name.range(of: query, options: [.diacriticInsensitive, .caseInsensitive]) != nil
}

struct Advertisment: Identifiable {
    var id: UUID = .init()
    let text: String
}

func randomItemsGenerator() -> [AnyIdentifiable] {
    var fruits: [AnyIdentifiable] = []
    for _ in 1 ... 20 {
        let fruit = AnyIdentifiable(id: UUID(), value: Fruit(name: "Lorem ipsum", symbol: "$#", color: FruitColor.allCases.randomElement()!))
        fruits.append(fruit)
    }
    return fruits
}

#endif
