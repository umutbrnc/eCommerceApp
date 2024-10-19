//
//  HomeViewModel.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation
import RxSwift
import UIKit

class HomeViewModel {
    
    var currentUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var products = BehaviorSubject<[Product]>(value: [Product]())
    var repo = Repository()
    
    init(){
        fetchProducts()
        products = repo.products
        currentUser = repo.currentUser
    }
    
    func addToCart(ad:String,resim:String,kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String){
        repo.addToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
    func fetchProducts(){
        repo.fetchProducts()
    }
    
    func searchProduct(searchText:String){
        repo.searchProduct(searchText: searchText)
    }
    
    func sortProducts(key:String){
        repo.sortProducts(key: key)
    }
    
    func fetchCurrentUserData(){
        repo.fetchCurrentUserData()
    }
    
    func categoryProduct(key:String){
        repo.categoryProduct(key: key)
    }
    
    func makeAlert( titleInput: String , messageInput: String, view: UIViewController){
        repo.makeAlert(titleInput: titleInput, messageInput: messageInput, view: view)
    }
    
    
}
