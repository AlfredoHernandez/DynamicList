//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct Topic<Item> {
    public let name: String
    public let predicate: (Item) throws -> Bool

    public init(name: String, predicate: @escaping (Item) throws -> Bool) {
        self.name = name
        self.predicate = predicate
    }
}
