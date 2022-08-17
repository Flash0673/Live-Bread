//
//  Cart.swift
//  Live Bread
//
//  Created by Nikita Rybakovskiy on 13.12.2021.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
    
//    init(item: Item, quantity: Int) {
//        self.item = item
//        self.quantity = quantity
//    }
}
