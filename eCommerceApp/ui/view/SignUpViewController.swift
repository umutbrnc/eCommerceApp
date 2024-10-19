//
//  SignUpViewController.swift
//  eCommerceApp
//
//  Created by chvck on 12.10.2024.
//

import UIKit

class SignUpViewController: UIViewController {

    var viewModel = SignUpViewModel()
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        if txtUsername.text == ""{
            viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "Username does not exist", view: self)
          }else if txtEmail.text == ""{
              viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "E-mail does not exist", view: self)
          }else if txtPassword.text == ""{
              viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "Password does not exist", view: self)
          }else if txtRePassword.text == ""{
              viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "Confirm Password does not exist", view: self)
          }else if txtPassword.text != txtRePassword.text{
              viewModel.makeAlert(titleInput: "Error!", messageInput: "Passwords don't match", view: self)
          }else if txtName.text == ""{
              viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "Name does not exist", view: self)
          }else if txtSurname.text == ""{
              viewModel.makeAlert(titleInput: "Fill the blanks!", messageInput: "Surname does not exist", view: self)
          }else{
              viewModel.signUp(email:txtEmail.text!,password:txtPassword.text!,username:txtUsername.text!,name:txtName.text!,surname:txtSurname.text!,view:self)
          }
        viewModel.makeAlert(titleInput: "Kayıt Tamamlandı", messageInput: "Kaydınız başarılı bir şekilde oluşturulmuştur.", view: self)
          performSegue(withIdentifier: "toLoginVC", sender: nil)
        
    }
    
}
