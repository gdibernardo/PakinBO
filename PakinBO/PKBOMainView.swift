//
//  PKBOMainView.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 20/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit


class PKBOMainView: UIView
{
    var mainMapView: GMSMapView?
    
    var searchBar: PKBOSearchBar?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        mainMapView = GMSMapView(frame: frame)
        
        searchBar = PKBOSearchBar.mapSearchBar(PKBOSearchBarPreferredContent.preferredSearchBarFrameInMapFrame(frame))
        
        mainMapView?.addSubview(searchBar!)
        
        
        self.addSubview(mainMapView!)
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
