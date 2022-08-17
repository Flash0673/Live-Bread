//
//  CartView.swift
//  Live Bread
//
//  Created by Nikita Rybakovskiy on 13.12.2021.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {present.wrappedValue.dismiss()}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.black)
                }
                
                Text("Моя корзина:")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(spacing: 0) {
                    ForEach(homeData.cartItems){cart in
                        
                        HStack {
                            Image(uiImage: UIImage(named: cart.item.itemImage)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(cart.item.itemName)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    
                                Text(cart.item.itemDetails)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                HStack(spacing: 15) {
                                    Text(homeData.getPrice(value: Int(truncating: cart.item.itemCost)))
                                        .font(.title3)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {
                                        if cart.quantity > 1 {
                                            homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                    Button(action: {
                                            homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                }
                            }
                        }
                        .padding()
                        .contextMenu{
                            
                            Button(action: {
                                let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: true)

                                homeData.items[itemIndex].isAdded = false
                                homeData.filtered[itemIndex].isAdded = false

                                
                                homeData.cartItems.remove(at: index)
                            }, label: {
                                Text("Удалить")
                            })
                        }
                    }
                    
                }
            }
            
            VStack {
                HStack {
                    Text("Всего:")
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(homeData.calculateTotalPrice())
                        .font(.title )
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    
                }
                .padding([.top, .horizontal])
                
                Button(action: homeData.updateOrder, label: {
                    Text(homeData.ordered ? "Отменить заказ" : "Оплатить")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color(.black))
                        .cornerRadius(15)
                })
            
            }
            .background(Color("white"))
            
            
            
        }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

