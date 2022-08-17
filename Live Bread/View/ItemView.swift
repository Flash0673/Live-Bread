//
//  ItemView.swift
//  Live Bread
//
//  Created by Nikita Rybakovskiy on 12.12.2021.
//

import SwiftUI

struct ItemView: View {
    var item: Item

    var body: some View {
        VStack{
            Image(uiImage: UIImage(named: item.itemImage)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
            
            Spacer(minLength: 60)
            
            HStack(spacing: 8) {
                Text(item.itemName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                Text("\(item.itemCost) руб")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 10)
            
            HStack {
                Text(item.itemDetails)
                    .font(.subheadline)
                    .foregroundColor(.black)
//                    .lineLimit(0)
                
                Spacer(minLength: 0)
            }
            Spacer(minLength: 45)
        }
    }
}

