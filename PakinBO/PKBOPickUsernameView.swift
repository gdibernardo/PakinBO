//
//  PKBOPickUsernameView.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 20/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOPickUsernameView: UIView
{

    lazy var usernameTextField: UITextField =
    {
        let lazilyIstantiatedUsernameTextField = UITextField(frame: CGRectMake(10, 100, self.frame.size.width - 20, 50))
        
        lazilyIstantiatedUsernameTextField.layer.borderColor = UIColor.blackColor().CGColor
        lazilyIstantiatedUsernameTextField.layer.borderWidth = 0.7
        lazilyIstantiatedUsernameTextField.textAlignment = .Center
        lazilyIstantiatedUsernameTextField.placeholder = "Username"
        
        return lazilyIstantiatedUsernameTextField
    }()
    
    lazy var profilePictureImageView: UIImageView =
    {
        let lazilyIstantiatedProfilePictureImageView = UIImageView(frame:CGRectMake(self.frame.width/3, self.usernameTextField.frame.origin.y + self.usernameTextField.frame.size.height + 50, self.frame.width/3, self.frame.width/3))
        lazilyIstantiatedProfilePictureImageView.clipsToBounds = true
        lazilyIstantiatedProfilePictureImageView.layer.borderColor = UIColor.blackColor().CGColor
        lazilyIstantiatedProfilePictureImageView.layer.cornerRadius = lazilyIstantiatedProfilePictureImageView.frame.size.width/2
        lazilyIstantiatedProfilePictureImageView.layer.borderWidth = 0.7
        return lazilyIstantiatedProfilePictureImageView
    }()
    
    var signupButton: UIButton?
    
    override init(frame: CGRect)
    {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        self.addSubview(usernameTextField)
        self.addSubview(profilePictureImageView)
        
        signupButton = UIButton(frame: CGRectMake(10, frame.size.height - 70, frame.size.width, 50))
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
