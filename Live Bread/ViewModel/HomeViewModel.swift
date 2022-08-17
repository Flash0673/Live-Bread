//
//  HomeViewModel.swift
//  Live Bread
//
//  Created by Nikita Rybakovskiy on 07.12.2021.
//

import SwiftUI
import CoreLocation
import Firebase
//Fetching User Location....
class HomeViewModel: NSObject,ObservableObject, CLLocationManagerDelegate  {
    
    @Published var locationManager = CLLocationManager() 
    @Published var search = ""
    
    //location details....
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    //Menu...
    @Published var showMenu = false
    
    //Item data...
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    @Published var cartItems: [Cart] = []
    @Published var ordered = false
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //Checking location....
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //reading user location and extracting details
        self.userLocation = locations.last
        self.extractLocation()
        self.login()
    }
    
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            
            guard let safeData = res else{return}
            
            var address = ""
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
            
        }
    }
    
    
    func login() {
        Auth.auth().signInAnonymously() {(res, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            
            self.fetchData()
        }
    }
    
    
    func fetchData() {
        let db = Firestore.firestore()
        
        db.collection("Items").getDocuments { (snap, err) in
            guard let itemData = snap else{return}
            
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                let id = doc.documentID
                let name = doc.get("itemName") as! String
                let cost = doc.get("itemCost") as! NSNumber
                let details = doc.get("itemDetails") as! String
                let image = doc.get("itemImage") as! String
                
                return Item(id: id, itemName: name, itemCost: cost, itemDetails: details, itemImage: image)
            })
            self.filtered = self.items
        }
    }
    
    func filterData() {
        withAnimation(.linear){self.filtered = self.items.filter{
            return $0.itemName.lowercased().contains(self.search.lowercased())
             }
        }
    }
    
    func addToCart(item: Item){
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        let filterIndex = self.filtered.firstIndex{ (item1) -> Bool in
            return item.id == item1.id
            
        } ?? 0

        self.filtered[filterIndex].isAdded = !item.isAdded

        if item.isAdded {
            
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            
            return
        }
        
        self.cartItems.append(Cart(item: item, quantity: 1))
        
        
    }
    
    func getIndex(item: Item, isCartIndex: Bool) -> Int{
        
        let index = self.items.firstIndex{ (item1) -> Bool in
            
            return item.id == item1.id
            
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex{ (item1) -> Bool in
            
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    
    func calculateTotalPrice() -> String {
        var price: Int = 0
        
        cartItems.forEach{ (item) in
            price += Int(item.quantity) * Int(truncating: item.item.itemCost)
        }
        return getPrice(value: price)
    }
    
//    func getPrice(value: Float) -> String {
//        let format = NumberFormatter()
//        format.numberStyle = .currency
//        return format.string(from: NSNumber(value: value)) ?? ""
//    }
    func getPrice(value: Int) -> String {
        return "\(String(value)) руб"
    }
    
    func updateOrder() {
        let db = Firestore.firestore()
        
        if ordered {
            ordered = false
            
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete { (err) in
                if err != nil {
                    self.ordered = true
                }
                
            }
            return
        }

        
        var details: [[String : Any]] = []
        
        cartItems.forEach{ (cart) in
            
            details.append([
                "itemName" : cart.item.itemName,
                "itemQuantity" : cart.quantity,
                "itemCost" : cart.item.itemCost
            ])
            
        }
        
        ordered = true
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "orderedFood" : details,
            "totalCost" : calculateTotalPrice(),
            "location" : GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
        ]) { (err) in
            
            if err != nil {
                self.ordered = false
                return
            }
            
            print("Success")
        }
        
    }
}
