//
//  Extension.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation
import UIKit


extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UISearchBarDelegate,ProductCellProtocol{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.row]
        
        cell.lblName.text = product.ad
        cell.lblPrice.text = "\(product.fiyat!) ₺"
        cell.lblComment.text = product.marka
        cell.showImage(imageName:product.resim!)
        cell.layer.cornerRadius = 18
        cell.cellProtocol = self
        cell.indexPath = indexPath
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: product)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            if let product = sender as? Product {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.product = product
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchProducts()
        } else {
            viewModel.searchProduct(searchText:searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
       }
    
    func configureMenuActions() {
          
          if #available(iOS 15.0, *) {
              
              let def = UIAction(title: "Normal", handler: { action in
                  self.handleMenuSelection(filter: "def")
              })
              let alpha = UIAction(title: "Alfabetik", handler: { action in
                  self.handleMenuSelection(filter: "alpha")
              })
              let priceInc = UIAction(title: "Fiyata Göre Artan", handler: { action in
                  self.handleMenuSelection(filter: "priceInc")
              })
              let priceDec = UIAction(title: "Fiyata Göre Azalan", handler: { action in
                  self.handleMenuSelection(filter: "priceDec")
              })

              let menu = UIMenu(title: "Filtreleme", children: [def, alpha, priceInc, priceDec])
              
              btnFilter.menu = menu
              btnFilter.showsMenuAsPrimaryAction = true
          }
      }
      
    func handleMenuSelection(filter: String) {
        btnFilter.setImage(UIImage(named: filter), for: .normal)
        self.viewModel.sortProducts(key: filter)
    }
    
     func selectButton(_ button: UIButton) {
            button.tintColor = .lavender
            button.isSelected = true
        self.viewModel.categoryProduct(key: (button.titleLabel?.text)!)
        }
        
     func resetButtons() {
             let buttons = [btnAll,btnTech,btnKoz,btnAc]
             for button in buttons {
                 button?.tintColor = UIColor.lightPurple
                 button?.isSelected = false
                 
             }
         }
}



extension CartViewController : UITableViewDelegate,UITableViewDataSource,CartProductCellProtocol{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartProductCell", for: indexPath) as! CartProductTableViewCell
        let cartProduct = cartProducts[indexPath.row]
        
        cell.cartProductCellProtocol = self
        cell.indexPath = indexPath
        
        cell.lblAd.text = cartProduct.ad
        cell.lblFiyat.text = "\(String(cartProduct.fiyat!))₺"
        cell.lblMarka.text = cartProduct.marka
        cell.showImage(imageName:cartProduct.resim!)
        cell.lblStepper.text = String(cartProduct.siparisAdeti!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let productToDelete = self.cartProducts[indexPath.row]
            self.viewModel.removeCartProduct(sepetId: productToDelete.sepetId!, kullaniciAdi: productToDelete.kullaniciAdi!)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}



    
    
extension ProfileViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         picker.dismiss(animated: true, completion: nil)
         
         if let selectedImage = info[.originalImage] as? UIImage {
             imgScreen.image = selectedImage

             UserDefaults.standard.saveProfileImage(selectedImage)
         }
     }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}




extension UserDefaults {
    
    private enum Keys {
        static let profileImage = "profileImage"
    }
    
    func saveProfileImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            set(imageData, forKey: Keys.profileImage)
        }
    }
    
    func getProfileImage() -> UIImage? {
        if let imageData = data(forKey: Keys.profileImage) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
    





extension PreviousOrderViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! PreviousOrderTableViewCell
        cell.lblOrder.text = "Sipariş Numarası : \(indexPath.row + 1)"
        cell.layer.cornerRadius = 15
        cell.lblPrice.text = "Ödenen : \(orderPrices[indexPath.row])₺"

        cell.lblDate.text = getCurrentDateTime()
        return cell
    }
    
    func getCurrentDateTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func setupEmptyMessage() {
         let emptyMessageLabel = UILabel()
         emptyMessageLabel.text = "Henüz sipariş vermediniz"
         emptyMessageLabel.textAlignment = .center
         emptyMessageLabel.textColor = .gray
         emptyMessageLabel.numberOfLines = 0
         
  
         tableViewOrders.backgroundView = emptyMessageLabel
         

         if orderPrices.isEmpty {
             tableViewOrders.backgroundView?.isHidden = false
         } else {
             tableViewOrders.backgroundView?.isHidden = true
         }
     }
    
}
    
    
    
    
    
    
    
    

