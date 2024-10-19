//
//  DetailViewController.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var lblAd: UILabel!
    @IBOutlet weak var lblKategori: UILabel!
    @IBOutlet weak var lblFiyat: UILabel!
    @IBOutlet weak var lblMarka: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    var product : Product?
    var viewModel = DetailViewModel()
    var currentUser : User?
    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let product = product{
            lblAd.text = product.ad
            lblKategori.text = "Kategori : \(product.kategori!)"
            lblFiyat.text = "\(product.fiyat!) ₺"
            lblMarka.text = product.marka
            showImage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.fetchCurrentUserData()
        
        _ = viewModel.currentUser.subscribe(onNext: { [self] user in
            self.currentUser = user
 
        })
        count = 1
        lblCount.text = String(count)
    }
    
    @IBAction func btnAddToCartClicked(_ sender: Any) {
        
        if let product = product {
            viewModel.addToCart(ad: product.ad!, resim: product.resim!, kategori: product.kategori!, fiyat: product.fiyat!, marka: product.marka!, siparisAdeti: self.count, kullaniciAdi: self.currentUser!.username!)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func btnMinusClicked(_ sender: Any) {
        if count >= 1{
            count -= 1
            lblCount.text = String(count)
        }
      
    }
    
    @IBAction func btnPlusClicked(_ sender: Any) {
        count += 1
        lblCount.text = String(count)
    }
    
    func showImage(){
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product!.resim!)") {
            DispatchQueue.main.async {
                self.imgProduct.kf.setImage(with: url)
            }
        }
    }
}

