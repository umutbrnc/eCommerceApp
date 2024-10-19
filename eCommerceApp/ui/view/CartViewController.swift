//
//  CartViewController.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import UIKit
import RxSwift
import FirebaseCore
import FirebaseFirestore

class CartViewController: UIViewController {
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tableViewCartProducts: UITableView!
    
    var cartProducts = [CartProduct]()
    var viewModel = CartViewModel()
    var currentUser : User?
    var currentUsername :String?
    let firestore = Firestore.firestore()
  
    @IBOutlet weak var lblProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewCartProducts.delegate = self
        tableViewCartProducts.dataSource = self
        
        _ = viewModel.totalPrice
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] total in
                self?.lblTotalPrice.text = "Toplam : \(total)₺"
            })
        
        _ = viewModel.cartProducts.subscribe(onNext: { list in
            
            self.cartProducts = list
            DispatchQueue.main.async {
                self.tableViewCartProducts.reloadData()
                self.setupEmptyMessage()
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.fetchCurrentUserData()
        if let profileImage = UserDefaults.standard.getProfileImage() {
            lblProfile.image = profileImage
               }
        
          _ = viewModel.currentUser.subscribe(onNext: { [weak self] user in
              if let username = user?.username {
                  self?.currentUsername = username
                  self?.viewModel.fetchCartProducts(kullaniciAdi: username)
                  self?.viewModel.calculateTotalPrice(kullaniciAdi: username)
                  self!.lblUsername.text = username
              }
          })
      
        
    }
    
    func minusClicked(indexPath: IndexPath) {
        viewModel.deleteFromCart(ad: cartProducts[indexPath.row].ad!, resim: cartProducts[indexPath.row].resim!, kategori: cartProducts[indexPath.row].kategori!, fiyat: cartProducts[indexPath.row].fiyat!, marka: cartProducts[indexPath.row].marka!, siparisAdeti: 1 , kullaniciAdi: self.currentUsername!)
        setupEmptyMessage()
    }
    
    func plusClicked(indexPath: IndexPath) {
        viewModel.addToCart(ad: cartProducts[indexPath.row].ad!, resim: cartProducts[indexPath.row].resim!, kategori: cartProducts[indexPath.row].kategori!, fiyat: cartProducts[indexPath.row].fiyat!, marka: cartProducts[indexPath.row].marka!, siparisAdeti: 1 , kullaniciAdi: self.currentUsername!)

        
        
    }
    
    
    @IBAction func btnComplete(_ sender: Any) {
        
        viewModel.makeAlert(titleInput: "Sipariş Tamamlandı", messageInput: "Siparişiniz başarılı bir şekilde alınmıştır.", view: self)

        let totalPrice = try? viewModel.totalPrice.value()
        var previousOrders = UserDefaults.standard.array(forKey: "orderPrices") as? [Int] ?? [Int]()
        previousOrders.append(totalPrice ?? 0)
        UserDefaults.standard.set(previousOrders, forKey: "orderPrices")

        for product in cartProducts {
              if let sepetId = product.sepetId {
                  self.viewModel.removeCartProduct(sepetId: sepetId, kullaniciAdi: self.currentUsername!)
              }
          }   
        
        setupEmptyMessage()
        
        self.viewModel.calculateTotalPrice(kullaniciAdi: self.currentUsername!)
        tabBarController?.selectedIndex = 2

    }
    
    
    func setupEmptyMessage() {
        
         let emptyMessageLabel = UILabel()
         emptyMessageLabel.text = "Sepetinizde ürün yok"
         emptyMessageLabel.textAlignment = .center
         emptyMessageLabel.textColor = .gray
         emptyMessageLabel.numberOfLines = 0
         
         tableViewCartProducts.backgroundView = emptyMessageLabel
         
         if cartProducts.isEmpty {
             tableViewCartProducts.backgroundView?.isHidden = false
         } else {
             tableViewCartProducts.backgroundView?.isHidden = true
         }
     }
    
    
    
}




