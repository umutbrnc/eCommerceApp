//
//  Profile.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    
    var viewModel = ProfileViewModel()
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgScreen: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchCurrentUserData()
        
        _ = viewModel.currentUser.subscribe(onNext: { [self] user in
            
            if let user = user{
                self.lblName.text = "\(user.name!) \(user.surname!)"
                self.lblUsername.text = user.username
                self.lblEmail.text = user.email
                
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let profileImage = UserDefaults.standard.getProfileImage() {
            imgScreen.image = profileImage
        }
        
        viewModel.fetchCurrentUserData()
        _ = viewModel.currentUser.subscribe(onNext: { [self] user in
            
            if let user = user{
                self.lblName.text = "\(user.name!) \(user.surname!)"
                self.lblUsername.text = user.username
                self.lblEmail.text = user.email
                
            }
            
        })
        
    }
    
    @IBAction func btnLogoutClicked(_ sender: Any) {
        
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
        viewModel.logout()
        performSegue(withIdentifier: "toLogout", sender: nil)
    }
    
    @IBAction func btnImgPicker(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    

    
}
