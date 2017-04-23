//
//  FindShowTonightTableViewCell.swift
//  FindShowTonight
//
//  Created by Ognam.Chen on 2017/4/21.
//  Copyright © 2017年 Gates. All rights reserved.
//

import UIKit

class FindShowTonightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
