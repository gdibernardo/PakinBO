//
//  PKBOCollectionViewCell.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 03/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOCollectionViewCell: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSizeMake(1, 4)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
