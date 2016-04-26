//
//  PKBOSelectTimeView.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOSelectTimeView: UIView
{
    
    var timePicker: UIDatePicker?
    
    var dismissButton: UIButton?

    var descriptionLabel: UILabel?
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    
        self.descriptionLabel = UILabel(frame: CGRectMake(10, 10, frame.size.width - 20, 50))
        self.descriptionLabel?.textAlignment = .Center
        self.descriptionLabel?.textColor = UIColor.blackColor()
        
        self.addSubview(self.descriptionLabel!)
        
        self.timePicker = UIDatePicker(frame: CGRectMake(0, 60, frame.size.width, frame.size.height/2))
        self.timePicker?.datePickerMode = .Time
        
        self.addSubview(timePicker!)
        
        dismissButton = UIButton(frame: CGRectMake(10, frame.size.height - 60, frame.size.width - 20, 50))
        dismissButton?.setTitle("OK", forState: .Normal)
        dismissButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addSubview(self.dismissButton!)
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
