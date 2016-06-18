//
//  ImageCell.swift
//  SlideMenu
//
//  Created by Prasad Pai on 05/06/16.
//  Copyright © 2016 Prasad Pai. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgView.layer.borderWidth = 2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
