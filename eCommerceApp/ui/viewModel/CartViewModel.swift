//
//  CartViewModel.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation
import RxSwift
import UIKit

class CartViewModel {
    
    var currentUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var cartProducts = BehaviorSubject<[CartProduct]>(value: [CartProduct]())
    var totalPrice = BehaviorSubject<Int>(value: 0)
    var repo = Repository()
    
    init(){
      cartProducts = repo.cartProducts
        currentUser = repo.currentUser
        totalPrice = repo.totalPrice
    }
    
    func makeAlert( titleInput: String , messageInput: String, view: UIViewController){
        repo.makeAlert(titleInput: titleInput, messageInput: messageInput, view: view)
    }
    
    func calculateTotalPrice(kullaniciAdi: String) {
           repo.calculateTotalPrice(kullaniciAdi: kullaniciAdi)
       }
    
    func fetchCartProducts(kullaniciAdi:String){
        repo.fetchCartProducts(kullaniciAdi: kullaniciAdi)
    }
    
    func removeCartProduct(sepetId:Int,kullaniciAdi:String){
        repo.removeCartProduct(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
    }
    
    func fetchCurrentUserData(){
        repo.fetchCurrentUserData()
    }
    
    func deleteFromCart(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String){
        repo.deleteFromCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
    func addToCart(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String){
        repo.addToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
}
