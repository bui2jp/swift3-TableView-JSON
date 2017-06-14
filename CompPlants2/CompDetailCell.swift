//
//  CompDetailCell.swift
//  CompPlants2
//
//  Created by Takuya on 2017/05/29.
//  Copyright © 2017年 Takuya. All rights reserved.
//

import UIKit

class CompDetailCell: UITableViewCell {

    
    @IBOutlet weak var nameText: UILabel!
    

    @IBOutlet weak var regCrossImg: UIImageView!
    @IBOutlet weak var veg_image: UIImageView!
    
    @IBOutlet weak var descText: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
