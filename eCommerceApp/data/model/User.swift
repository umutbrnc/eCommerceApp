//
//  User.swift
//  eCommerceApp
//
//  Created by chvck on 13.10.2024.
//

import Foundation

class User :Codable{
    
    var name : String?
    var surname : String?
    var username: String?
    var email : String?

    
    init(name: String, surname: String, username: String, email: String) {
        self.name = name
        self.surname = surname
        self.username = username
        self.email = email

    }
    
    
}
