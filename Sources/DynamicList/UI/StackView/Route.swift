//
//  File.swift
//  
//
//  Created by Jesús Alfredo Hernández Alarcón on 21/05/24.
//

import Foundation

final class NavigationRouter<Item: Identifiable & Hashable>: ObservableObject {
    @Published var routes = [Route<Item>]()
}

public enum Route<Item: Identifiable & Hashable>: Hashable {
    case detail(forItem: Item)
}
