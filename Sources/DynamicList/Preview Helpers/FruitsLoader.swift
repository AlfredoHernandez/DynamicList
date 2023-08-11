//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import Foundation

#if DEBUG
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

func testFruitsLoader() -> AnyPublisher<[AnyIdentifiable], Error> {
    fruitsLoader.map { fruits in
        fruits.map { AnyIdentifiable(id: $0.id, value: $0) }
    }
    .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
    .eraseToAnyPublisher()
}
#endif
