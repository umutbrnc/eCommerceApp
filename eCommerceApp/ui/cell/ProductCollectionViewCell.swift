//
//  ProductsCollectionViewCell.swift
//  eCommerceApp
//
//  Created by chvck on 13.10.2024.
//

import UIKit

protocol ProductCellProtocol {
    func addToCartClicked(indexPath:IndexPath)
    func favClicked(indexPath:IndexPath)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    var cellProtocol : ProductCellProtocol?
    var indexPath : IndexPath?
    
    
    func showImage(imageName:String){
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            DispatchQueue.main.async {
                self.imgProduct.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction func btnAddToCartClicked(_ sender: Any) {
        cellProtocol?.addToCartClicked(indexPath: indexPath!)
      
        
    }

    @IBAction func favClicked(_ sender: UIButton) {
      //  cellProtocol?.favClicked(indexPath: indexPath!)
        
        
    }
    
    
}
