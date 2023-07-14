//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct AnyIdentifiable: Identifiable {
    public let id: AnyHashable
    public let value: Any

    public init(_ id: some Hashable, _ value: some Any) {
        self.id = AnyHashable(id)
        self.value = value
    }
}
