//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine

class LoaderSpy<Item> {
    private var completions = [PassthroughSubject<[Item], Error>]()
    var loadCallCount: Int { completions.count }

    func complete(with items: [Item] = [], at index: Int = 0) {
        completions[index].send(items)
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index].send(completion: .failure(error))
    }

    func publisher() -> AnyPublisher<[Item], Error> {
        let publisher = PassthroughSubject<[Item], Error>()
        completions.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
}
