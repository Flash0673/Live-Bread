//
//  Home.swift
//  Live Bread
//
//  Created by Nikita Rybakovskiy on 07.12.2021.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        
        ZStack {
            VStack(spacing: 10){
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.black)})
                    Text(HomeModel.userLocation == nil ? "Ищем..." : "Ваш адрес:")
                        .foregroundColor(.black)
                        .font(.callout)
                        .fontWeight(.semibold)

                    
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer(minLength: 0)
                }
                .padding([.horizontal,.top])
                
                Divider()
                
                HStack(spacing: 15) {
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray )
                    
                    TextField("Искать...", text: $HomeModel.search)
        
                }
                .padding(.horizontal)
                .padding(.top,10)
                Divider()
                
                if HomeModel.items.isEmpty {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
                else {
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack(spacing: 25) {
                            ForEach(HomeModel.filtered){item in
                                
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                    ItemView(item: item)
                                    
                                    HStack {
                                 
                                        Spacer(minLength: 0)
                                        
                                        Button(action: {
                                            HomeModel.addToCart(item: item)
                                        }, label: {
                                            Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20, weight: .medium))
                                                .padding()
                                                .background(Color(.white))
                                                .clipShape(Circle())
                                                
                                        })
                                    }
                                    .padding(.trailing)
                                    .padding(.top, -20)
                                        
                                })
                                .frame(width: UIScreen.main.bounds.width - 30)
                                
                            }
                        }
                        .padding(.top, 50)
                    })
                }
            }
            //side menu...
            HStack {
                Menu(homeData: HomeModel) 
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                //closing when taps outside
                    .onTapGesture(perform: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                        
                    })
            )
            
            if HomeModel.noLocation {
                Text("Please enable location access in setting to move on!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
            
        }
        .onAppear(perform: {
            //colling localization deligate
            HomeModel.locationManager.delegate = HomeModel
            
            
        })
        .onChange(of: HomeModel.search, perform: {value in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                if value == HomeModel.search && HomeModel.search != ""{
                    
                    //search data...
                    HomeModel.filterData()
                }
            }
            if HomeModel.search == "" {
                withAnimation(.linear){HomeModel.filtered = HomeModel.items}
            }
            
        })
    }
}

