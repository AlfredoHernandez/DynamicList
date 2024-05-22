//
//  Copyright © 2024 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

final class NavigationRouter<Item: Identifiable & Hashable>: ObservableObject {
    @Published var routes = [Route<Item>]()
}

public enum Route<Item: Identifiable & Hashable>: Hashable {
    case detail(forItem: Item)
}
