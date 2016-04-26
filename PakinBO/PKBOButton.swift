//
//  PKBOButton.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 20/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

enum PKBOType
{
    case PKBOTypeMapCenterUserType
    case PKBOTypeMapAddPakiType
    case PKBOTypeMapDirectionType
}

struct PKBOButtonPreferredContent
{

    static let PKBOInsetFromRightEdge: CGFloat = 10.0
    
    static let PKBOMapButtonPreferredSize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width/6, UIScreen.mainScreen().bounds.size.width/6)
    
  
    static func preferredFrameForAddPakiButtonInFrame(frame: CGRect) -> CGRect
    {
        return CGRectMake(frame.size.width - PKBOMapButtonPreferredSize.width - PKBOInsetFromRightEdge, frame.size.height - PKBOInsetFromRightEdge * 4 - PKBOMapButtonPreferredSize.height * 2, PKBOMapButtonPreferredSize.width, PKBOMapButtonPreferredSize.height)
    }
    
    static func preferredFrameForCenterUserButtonInFrame(frame: CGRect) -> CGRect
    {
        return CGRectMake(frame.size.width - PKBOMapButtonPreferredSize.width - PKBOInsetFromRightEdge, frame.size.height - PKBOInsetFromRightEdge * 2 - PKBOMapButtonPreferredSize.height, PKBOMapButtonPreferredSize.width, PKBOMapButtonPreferredSize.height)
    }
}


class PKBOButton: UIButton
{
    
    var type: PKBOType?
    
    override var highlighted: Bool
        {
        didSet
        {
            if(highlighted)
            {
                self.layer.shadowRadius = 5.0
                self.layer.shadowOpacity = 0.85
                self.layer.shadowOffset = CGSizeMake(1, 5)
            }
            else
            {
                self.layer.shadowRadius = 4.0
                self.layer.shadowOpacity = 0.6
                self.layer.shadowOffset = CGSizeMake(1, 4)
            }
        }
    }

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSizeMake(1, 4)
    }

    private static func mapButton(frame: CGRect) -> PKBOButton?
    {
        let button = PKBOButton(frame: frame)
        
        button.layer.cornerRadius = frame.size.width/2
        
        
        return button
    }
    
    
    static func mapButton(frame:CGRect, withType type:PKBOType) -> PKBOButton?
    {
        let button = PKBOButton.mapButton(frame)
        
        button?.type = type
        
        let imageView: UIImageView
        switch(type)
        {
        case .PKBOTypeMapAddPakiType:
            button?.backgroundColor = UIColor.redColor()
            imageView = UIImageView(frame: CGRectMake(button!.frame.size.width/3, button!.frame.size.height/3, button!.frame.size.width/3, button!.frame.size.height/3))
            imageView.image = UIImage(named: "PlusIcon")
           
        case .PKBOTypeMapCenterUserType:
            button?.backgroundColor = UIColor.whiteColor()
            imageView = UIImageView(frame: CGRectMake(button!.frame.size.width/3, button!.frame.size.height/3, button!.frame.size.width/3, button!.frame.size.height/3))
            imageView.image = UIImage(named: "CenterIcon")
        case .PKBOTypeMapDirectionType:
            button!.backgroundColor = UIColor.blueColor()
            imageView = UIImageView(frame: CGRectMake(button!.frame.size.width/3, button!.frame.size.height/3, button!.frame.size.width/3, button!.frame.size.height/3))
            imageView.image = UIImage(named: "DirectionIcon")
        }
        
        button?.addSubview(imageView)
        return button
    }
    
    
    static func genericButton(frame frame: CGRect) -> PKBOButton?
    {
        let button = PKBOButton(frame: frame)
        
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
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
