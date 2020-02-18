//
//  CategoriesTableViewCell.swift
//  CoreDataGymList
//
//  Created by Onur Com on 17.02.2020.
//  Copyright © 2020 Onur Com. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var gView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
