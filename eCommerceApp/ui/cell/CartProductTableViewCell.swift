//
//  CartProductTableViewCell.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import UIKit

protocol CartProductCellProtocol {
    func minusClicked(indexPath:IndexPath)
    func plusClicked(indexPath:IndexPath)
}


class CartProductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblAd: UILabel!
    @IBOutlet weak var lblMarka: UILabel!
    @IBOutlet weak var lblFiyat: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblStepper: UILabel!
    
    var cartProductCellProtocol : CartProductCellProtocol?
    var indexPath : IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showImage(imageName:String){
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            DispatchQueue.main.async {
                self.imgProduct.kf.setImage(with: url)
            }
        }
    }
    
    
    @IBAction func btnMinusClicked(_ sender: Any) {
        cartProductCellProtocol?.minusClicked(indexPath: indexPath!)
    }
    
    @IBAction func btnPlusClicked(_ sender: Any) {
        cartProductCellProtocol?.plusClicked(indexPath: indexPath!)
    }
    
    
}
