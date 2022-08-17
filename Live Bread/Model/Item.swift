//
//  Item.swift
//  Live Bread
//
//  Created by Nikita Rybakovskiy on 11.12.2021.
//

import SwiftUI

struct Item: Identifiable {
    
    var id: String
    var itemName: String
    var itemCost: NSNumber
    var itemDetails: String
    var itemImage: String
    var isAdded: Bool = false
    
//    init (id: String, itemName: String, itemCost: NSNumber, itemDetails: String, itemImage: String) {
//        self.id = id
//        self.itemName = itemName
//        self.itemCost = itemCost
//        self.itemDetails = itemDetails
//        self.itemImage = itemImage
//    }
    
    
}
