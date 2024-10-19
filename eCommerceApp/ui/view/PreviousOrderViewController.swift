//
//  PreviousOrderViewController.swift
//  eCommerceApp
//
//  Created by chvck on 12.10.2024.
//

import UIKit
import RxSwift

class PreviousOrderViewController: UIViewController {

    @IBOutlet weak var tableViewOrders: UITableView!
    var orderPrices = [Int]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewOrders.delegate = self
        tableViewOrders.dataSource = self

        tableViewOrders.reloadData()
        setupEmptyMessage()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if let savedPrices = UserDefaults.standard.array(forKey: "orderPrices") as? [Int] {
            orderPrices = savedPrices
        }
        tableViewOrders.reloadData()
        setupEmptyMessage()
    }
 
        
}
