//
//  PKBOOpeningTimeShopView.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOOpeningTimeShopView: UIView
{

    var openingTimeButton: UIButton?
    var closingTimeButton: UIButton?
    
    var openingTime: String?
    {
        set
        {
            self.openingTimeButton?.setTitle(newValue, forState: .Normal)
        }
        get
        {
            return self.openingTimeButton?.titleLabel?.text
        }
    }
    
    var closingTime: String?
    {
        set
        {
            self.closingTimeButton?.setTitle(newValue, forState: .Normal)
        }
        get
        {
            return self.closingTimeButton?.titleLabel?.text
        }
    }
    
    override init(frame: CGRect)
    
    {
        super.init(frame: frame)
    
        self.backgroundColor = UIColor.whiteColor()
        self.openingTimeButton = UIButton(frame: CGRectMake(0, 0, frame.size.width/2 - 5, frame.size.height))
        self.openingTimeButton?.setTitle("-", forState: .Normal)
        self.openingTimeButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addSubview(self.openingTimeButton!)
        
        self.closingTimeButton = UIButton(frame: CGRectMake(frame.size.width/2 + 5, 0, frame.size.width/2 - 5, frame.size.height))
        self.closingTimeButton?.setTitle("-", forState: .Normal)
        self.closingTimeButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addSubview(self.closingTimeButton!)
        
        let distanceLabel = UILabel(frame: CGRectMake(frame.size.width/2 - 5, 0, 10, frame.size.height))
        distanceLabel.text = "-"
        
        self.addSubview(distanceLabel)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
