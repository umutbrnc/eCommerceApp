//
//  CartProductResponse.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation

class CartProductResponse : Codable {
    
    var urunler_sepeti : [CartProduct]?
    var success : Int?
    
}
