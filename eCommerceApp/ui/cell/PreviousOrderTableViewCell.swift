//
//  PreviousOrderTableViewCell.swift
//  eCommerceApp
//
//  Created by chvck on 18.10.2024.
//

import UIKit

class PreviousOrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
}
