//
//  DetailViewModel.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation
import RxSwift

class DetailViewModel {
    
    var currentUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var products = BehaviorSubject<[Product]>(value: [Product]())
    var repo = Repository()
    
    init(){
        products = repo.products
        currentUser = repo.currentUser
    }
    
    
    func addToCart(ad:String,resim:String,kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String){
        repo.addToCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
        
    func deleteFromCart(ad:String,resim:String,kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String){
        repo.deleteFromCart(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }

    func fetchCurrentUserData(){
        repo.fetchCurrentUserData()
    }
    
}
