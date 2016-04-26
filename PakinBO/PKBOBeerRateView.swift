//
//  PKBOBeerRateView.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 07/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

protocol PKBOBeerRateViewDelegate
{
    func beerRateView(beerView: PKBOBeerRateView, didTapBeerAtIndex index: Int)
}

class PKBOBeerRateView: UIView
{

    var delegate: PKBOBeerRateViewDelegate?
    
    var rate: Int = 0
    {
        didSet
        {
            if(rate < 0)
            {
                rate = 0
            }
            if(rate > 5)
            {
                rate = 5
            }
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        for(var index = 1; index <= 5; index++)
        {
            let button = UIButton(frame: CGRectMake(CGFloat(index - 1) * (frame.size.width/5), 0, frame.size.width/5, frame.size.width/5))
            button.tag = index
            
            button.setImage(UIImage(named: "BlackBeerIcon"), forState: .Normal)
            
            button.addTarget(self, action: "didTapBeerButton:", forControlEvents: .TouchUpInside)
         
            self.addSubview(button)
        }
    }
    
    

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func didTapBeerButton(sender: UIButton)
    {
        self.rate = sender.tag
        self.delegate?.beerRateView(self, didTapBeerAtIndex: sender.tag)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
