//
//  LoginViewModel.swift
//  eCommerceApp
//
//  Created by chvck on 12.10.2024.
//

import Foundation
import UIKit

class LoginViewModel{
    
    var repo = Repository()
    

    func login(email: String, password: String, view: UIViewController){
        repo.login(email: email, password: password, view: view)
    }
    
    func makeAlert( titleInput: String , messageInput: String, view: UIViewController){
        repo.makeAlert(titleInput: titleInput, messageInput: messageInput, view: view)
    }
    
}
