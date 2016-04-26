//
//  PKBOTableViewCell.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 07/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.whiteColor()
        
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(0.5, 0.5)
        self.selectionStyle = .None
       // self.layer.borderColor = UIColor.blackColor().CGColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
