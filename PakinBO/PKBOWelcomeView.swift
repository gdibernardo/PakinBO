//
//  PKBOWelcomeView.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 18/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

struct PKBOWelcomeViewPreferredContent
{
    static let PKBOPreferredDistanceFromBorder: CGFloat = 10.0;
    static let PKBOPreferredDistanceFromBottomFacebookLoginButton: CGFloat = 100;
}

class PKBOWelcomeView: UIView
{
    
    lazy var facebookLoginButton: UIButton = {
        var lazilyInstatiatedFacebookLoginButton = UIButton(frame: CGRectMake(PKBOWelcomeViewPreferredContent.PKBOPreferredDistanceFromBorder, self.frame.height - PKBOWelcomeViewPreferredContent.PKBOPreferredDistanceFromBottomFacebookLoginButton, self.frame.width - 2 * PKBOWelcomeViewPreferredContent.PKBOPreferredDistanceFromBorder, 50))
        lazilyInstatiatedFacebookLoginButton.setTitle("Login via FB", forState: .Normal)
        lazilyInstatiatedFacebookLoginButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        return lazilyInstatiatedFacebookLoginButton
        
        }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        
        addSubview(facebookLoginButton)
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
