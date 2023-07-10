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

struct FruitItemView: View {
    let item: Fruit

    var body: some View {
        HStack {
            Text(item.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            Spacer()
            Text(item.symbol)
        }
    }
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

struct FruitItemView_Previews: PreviewProvider {
    static var previews: some View {
        FruitItemView(item: Fruit(name: "Plátano", symbol: "🍌", color: .yellow))
            .previewLayout(.fixed(width: 340, height: 60))
    }
}
