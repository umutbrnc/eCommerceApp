//
//  SignUpViewModel.swift
//  eCommerceApp
//
//  Created by chvck on 12.10.2024.
//

import Foundation
import UIKit

class SignUpViewModel{
    
    var repo = Repository()
    
    func signUp(email: String, password: String, username: String,name:String,surname:String, view: UIViewController){
        repo.signUp(email: email, password: password, username: username, name: name, surname: surname, view: view)
    }
    
    func makeAlert( titleInput: String , messageInput: String, view: UIViewController){
        repo.makeAlert(titleInput: titleInput, messageInput: messageInput, view: view)
    }
    
}
