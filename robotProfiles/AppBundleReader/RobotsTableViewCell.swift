//
//  RobotsTableViewCell.swift
//  AppBundleReader
//
//  Created by Tony Cioara on 1/14/18.
//  Copyright © 2018 Eliel Gordon. All rights reserved.
//

import UIKit

class RobotsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var robotImage: UIImageView!
    
    var robot: Robot?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
