//
//  HomeVC.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import UIKit
import RxSwift
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnTech: UIButton!
    @IBOutlet weak var btnKoz: UIButton!
    @IBOutlet weak var btnAc: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    
    
    var products = [Product]()
    var viewModel = HomeViewModel()
    var currentUsername : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionViewProducts.delegate = self
        collectionViewProducts.dataSource = self
        selectButton(btnAll)
        
        collectionViewProducts.collectionViewLayout = setupDesign()
        
        _ = viewModel.products.subscribe(onNext: { list in
            self.products = list
            DispatchQueue.main.async {
                self.collectionViewProducts.reloadData()
            }
        })
        
        configureMenuActions()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {

        
        viewModel.fetchProducts()
        viewModel.fetchCurrentUserData()
        selectButton(btnAll)
        
        if let profileImage = UserDefaults.standard.getProfileImage() {
            imgProfile.image = profileImage
               }
        _ = viewModel.currentUser.subscribe(onNext: { [self] user in
          
            if let user = user{
                lblUsername.text = "\(String(describing: user.username!))"
                self.currentUsername = user.username
            }
 
        })
        
    }
    
    
    func addToCartClicked(indexPath: IndexPath) {

        viewModel.addToCart(ad: products[indexPath.row].ad!, resim: products[indexPath.row].resim!, kategori: products[indexPath.row].kategori!, fiyat: products[indexPath.row].fiyat!, marka: products[indexPath.row].marka!, siparisAdeti: 1, kullaniciAdi:self.currentUsername! )
        self.viewModel.makeAlert(titleInput: "Sepete Eklendi", messageInput: "Ürün başarıyla sepete eklendi.", view: self)
        
    }
    
    func favClicked(indexPath:IndexPath){

        
    }
    
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    @IBAction func btnImageclicked(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 3
        }
    }
    
    

    @IBAction func btnClicked(_ sender: UIButton) {
        resetButtons()
        selectButton(sender)

    }
    
    func setupDesign()->UICollectionViewFlowLayout{
        let design = UICollectionViewFlowLayout()
        design.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        design.minimumInteritemSpacing = 15
        design.minimumLineSpacing = 15

        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth-45)/2
        
        design.itemSize = CGSize(width: itemWidth, height: itemWidth*1.3)
        return design
    }
    

    
  }
    




