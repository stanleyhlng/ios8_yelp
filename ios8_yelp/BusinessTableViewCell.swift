//
//  BusinessTableViewCell.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var photoBoxImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    //var business: Business! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {
//        if business == nil {
//            return
//        }
//        
//        // Name
//        nameLabel.text = "abc"
    }
    
}
