//
//  Copyright © 2025 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct AnyIdentifiable: Identifiable, Hashable {
    public let id: AnyHashable
    public let value: Any

    public init(id: some Hashable, value: any Identifiable & Hashable) {
        self.id = AnyHashable(id)
        self.value = value
    }

    public static func == (lhs: AnyIdentifiable, rhs: AnyIdentifiable) -> Bool {
        lhs.id == rhs.id && "\(lhs.value)" == "\(rhs.value)"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine("\(value)")
    }
}
