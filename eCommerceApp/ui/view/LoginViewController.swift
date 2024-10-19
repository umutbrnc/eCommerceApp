//
//  LoginViewController.swift
//  eCommerceApp
//
//  Created by chvck on 12.10.2024.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        if txtEmail.text == ""{
            viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "E-mail does not exist",view:self)
        }else if txtPassword.text == ""{
            viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "Password does not exist",view:self)
        }else{
            viewModel.login(email: txtEmail.text!, password: txtPassword.text!, view: self)
        }
        
    }
 
    
    
 

}
