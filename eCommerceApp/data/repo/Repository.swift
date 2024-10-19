//
//  Repository.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation
import UIKit
import RxSwift
import Alamofire
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class Repository {
    
    var products = BehaviorSubject<[Product]>(value: [Product]())
    var cartProducts = BehaviorSubject<[CartProduct]>(value: [CartProduct]())
    var cartProductsTemp = [CartProduct]()
    var currentUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var totalPrice : BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    
    func fetchProducts(){
        
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        AF.request(url,method: .get).response {response in
            if let data = response.data {
                do{
                    let response = try JSONDecoder().decode(ProductResponse.self, from: data)
                    if let list = response.urunler{
                        self.products.onNext(list)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func fetchProductsWithCompletion(completion: @escaping () -> Void){
        
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        AF.request(url,method: .get).response {response in
            if let data = response.data {
                do{
                    let response = try JSONDecoder().decode(ProductResponse.self, from: data)
                    if let list = response.urunler{
                        self.products.onNext(list)
                        completion()
                    }
                }catch{
                    print(error.localizedDescription)
                    completion()
                }
            }
        }
    }
    
    
    func deleteFromCart(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        
        fetchCartProductsWithCompletion(kullaniciAdi: kullaniciAdi) {
            
            if let existingProduct = self.cartProductsTemp.first(where: { $0.ad == ad }) {
                let updatedQuantity = (existingProduct.siparisAdeti ?? 0) - siparisAdeti
                
                if updatedQuantity > 0 {
                    let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                    let params: Parameters = ["ad": ad,"resim": resim,"kategori": kategori,"fiyat": fiyat,"marka": marka,"siparisAdeti": updatedQuantity,"kullaniciAdi": kullaniciAdi]
                    
                    AF.request(url, method: .post, parameters: params).response { response in
                        if let data = response.data {
                            do {
                                let addResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
                                if addResponse.success == 1 {
                                    self.removeCartProduct(sepetId: existingProduct.sepetId!, kullaniciAdi: kullaniciAdi)
                                    self.calculateTotalPrice(kullaniciAdi: kullaniciAdi)
                                    
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } else {
                    self.removeCartProduct(sepetId: existingProduct.sepetId!, kullaniciAdi: kullaniciAdi)
                    self.calculateTotalPrice(kullaniciAdi: kullaniciAdi)
                    
                }
            }
        }
        
    }
    
    
    func addToCart(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        
        fetchCartProductsWithCompletion(kullaniciAdi: kullaniciAdi) {
            
            if let existingProduct = self.cartProductsTemp.first(where: { $0.ad == ad }) {
                let updatedQuantity = (existingProduct.siparisAdeti!) + siparisAdeti

                let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                let params: Parameters = ["ad": ad,"resim": resim,"kategori": kategori,"fiyat": fiyat,"marka": marka,"siparisAdeti": updatedQuantity,"kullaniciAdi": kullaniciAdi]
                
                AF.request(url, method: .post, parameters: params).response { response in
                    if let data = response.data {
                        do {
                            let addResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
                            if addResponse.success == 1 {
                                self.removeCartProduct(sepetId: existingProduct.sepetId!, kullaniciAdi: kullaniciAdi)
                                self.calculateTotalPrice(kullaniciAdi: kullaniciAdi)
                                
                            }
                        } catch {
                            print("Hata: \(error.localizedDescription)")
                        }
                    }
                }
                
            } else {
                
                let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                let params: Parameters = ["ad": ad,"resim": resim,"kategori": kategori,"fiyat": fiyat,"marka": marka,"siparisAdeti": siparisAdeti,"kullaniciAdi": kullaniciAdi]
                
                AF.request(url, method: .post, parameters: params).response { response in
                    if let data = response.data {
                        do {
                            let response = try JSONDecoder().decode(CRUDResponse.self, from: data)
                            print("Success : \(response.success!)")
                            print("Message : \(response.message!)")
                            self.calculateTotalPrice(kullaniciAdi: kullaniciAdi)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    
    func fetchCartProducts(kullaniciAdi: String) {
        
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: params).response { [self] response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(CartProductResponse.self, from: data)
                    if let list = response.urunler_sepeti {
                        self.cartProducts.onNext(list)
                        self.cartProductsTemp = list
                    }
                } catch {
                    self.cartProducts.onNext([])
                    self.cartProductsTemp = []
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func fetchCartProductsWithCompletion(kullaniciAdi: String, completion: @escaping () -> Void) {
        
        
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: params).response { [self] response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(CartProductResponse.self, from: data)
                    if let list = response.urunler_sepeti {
                        self.cartProductsTemp = list
                        completion()
                    }
                } catch {
                    completion()
                }
                
            }
        }
    }
    
    
    func calculateTotalPrice(kullaniciAdi: String) {
        
        fetchCartProductsWithCompletion(kullaniciAdi: kullaniciAdi) { [weak self] in
            guard let self = self else { return }
            let currentCartProducts = try? self.cartProducts.value()
            
            let total = currentCartProducts?.reduce(0) { $0 + (Int($1.fiyat ?? 0) * Int($1.siparisAdeti ?? 1)) } ?? 0
            
            DispatchQueue.main.async {
                self.totalPrice.onNext(total)
            }
        }
    }
    
    
    func removeCartProduct(sepetId: Int, kullaniciAdi: String) {
        
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        let params: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Success : \(response.success!)")
                    print("Message : \(response.message!)")
                    self.fetchCartProducts(kullaniciAdi: kullaniciAdi)
                    self.calculateTotalPrice(kullaniciAdi: kullaniciAdi)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    
    func searchProduct(searchText:String){
        
        guard let currentList = try? products.value() else {
            print("Error: Product list is empty")
            return
        }
        
        let filteredList = currentList.filter { $0.ad?.lowercased().contains(searchText.lowercased()) ?? false }
        products.onNext(filteredList)
    }
    
    
    func sortProducts(key:String){
        
        guard let currentList = try? products.value() else {
            print("Error: Product list is empty")
            return
        }
        
        switch key {
        case "priceInc":
            let sortedList = currentList.sorted { ($0.fiyat ?? 0) < ($1.fiyat ?? 0) }
            products.onNext(sortedList)
            
        case "alpha":
            let sortedList = currentList.sorted { ($0.ad?.lowercased() ?? "") < ($1.ad?.lowercased() ?? "") }
            products.onNext(sortedList)
            
        case "priceDec":
            let sortedList = currentList.sorted { ($0.fiyat ?? 0) > ($1.fiyat ?? 0) }
            products.onNext(sortedList)
        case "def":
            fetchProducts()
        default:
            return
        }
        
        
    }
    
    
    func categoryProduct(key:String){
        
        fetchProductsWithCompletion {
            guard let currentList = try? self.products.value() else {
                print("Error: Product list is empty")
                return
            }

            switch key {
            case "Teknoloji":
                let newList = currentList.filter { $0.kategori == "Teknoloji"}
                self.products.onNext(newList)
            case "Kozmetik":
                let newList = currentList.filter { $0.kategori == "Kozmetik"}
                self.products.onNext(newList)
            case "Aksesuar":
                let newList = currentList.filter { $0.kategori == "Aksesuar"}
                self.products.onNext(newList)
            case "Hepsi":
                self.fetchProducts()
            default:
                return
            }
        }
        
    }
    
    
    func makeAlert( titleInput: String , messageInput: String, view: UIViewController) {
        let Alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        Alert.addAction (okButton)
        view.present(Alert,animated: true)
    }
    
    
    func login(email: String, password: String, view: UIViewController){
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Unknown error", view: view)
            }else{
                view.performSegue(withIdentifier: "toLogin", sender: nil)
            }
        }
        
    }
    
    
    func signUp(email: String, password: String, username: String,name:String,surname:String, view: UIViewController){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription, view: view)
            } else {
                guard let user = authResult?.user else {
                    self.makeAlert(titleInput: "Error!", messageInput: "User doesn't create", view: view)
                    return
                }
                
                let firestore = Firestore.firestore()
                let userDictionary: [String: Any] = ["email": email, "username": username,"name":name,"surname":surname,]
                
                firestore.collection("userInfo").document(user.uid).setData(userDictionary) { error in
                    if let error = error {
                        self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription, view: view)
                    } else {
                        view.performSegue(withIdentifier: "toLoginVC", sender: nil)
                    }
                }
            }
        }
    }
    
    
    func logout(){
        
        do {
            try Auth.auth().signOut()
            print("Logout successful")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func fetchCurrentUserData(){
        
        guard let currentUser = Auth.auth().currentUser else {
            print("User not found!")
            return
        }
        
        let userId = currentUser.uid
        let firestore = Firestore.firestore()
        
        
        firestore.collection("userInfo").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists, let data = document.data(),
                  let fetchedUsername = data["username"] as? String,
                  let fetchedName = data["name"] as? String,
                  let fetchedSurname = data["surname"] as? String
            else {
                print("User data not found!")
                return
            }

            guard let email = currentUser.email else {
                print("User email not found!")
                return
            }

            let user = User(name: fetchedName, surname: fetchedSurname, username: fetchedUsername, email: email)

            self?.currentUser.onNext(user)
        }
        
        
    }
    


}
