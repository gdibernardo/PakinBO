//
//  PKBOAddPakiView.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOAddPakiView: UIView
{
    private var mainScrollView: UIScrollView?
    
    var mapView: GMSMapView?
    
    var nameTextField: UITextField?
    
    var timeView: PKBOOpeningTimeShopView?
    
    var saveShopButton: PKBOButton?
    
    var cancelButton: UIButton?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.mainScrollView = UIScrollView(frame: frame)
        //addSubview(self.mainScrollView!)
        
        self.mapView = GMSMapView(frame: CGRectMake(0, 0, self.mainScrollView!.frame.size.width, self.mainScrollView!.frame.size.height/3))
        self.mapView?.myLocationEnabled = true
        
        let markerView = UIImageView(frame:CGRectMake(self.mapView!.center.x,self.mapView!.center.y,30,30))
        markerView.image = UIImage(named: "RedMarker")
        self.mapView?.addSubview(markerView)
        
        self.addSubview(self.mapView!)
        
        self.nameTextField = UITextField(frame: CGRectMake(10, self.mapView!.frame.size.height + 20, self.mainScrollView!.frame.size.width - 20, 50))
        self.nameTextField?.backgroundColor = UIColor.whiteColor()
        self.nameTextField?.placeholder = "Shop name (Optional)"
        self.nameTextField?.textAlignment = .Center
        self.nameTextField?.returnKeyType = .Done
        self.addSubview(self.nameTextField!)
        
        timeView = PKBOOpeningTimeShopView(frame: CGRectMake(10, self.nameTextField!.frame.origin.y + self.nameTextField!.frame.size.height + 20, self.mainScrollView!.frame.size.width - 20, 50))
        
        self.addSubview(timeView!)
        
        self.saveShopButton = PKBOButton.genericButton(frame: CGRectMake(10, frame.size.height-60, frame.size.width - 20, 50))
        self.saveShopButton?.setTitle("Save", forState: .Normal)
        self.saveShopButton?.backgroundColor = UIColor.redColor()
        self.saveShopButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addSubview(self.saveShopButton!)
        
        self.cancelButton = UIButton(frame: CGRectMake(frame.size.width - 50, 25, 30, 30))
        self.cancelButton?.setImage(UIImage(named: "CancelIcon"), forState: .Normal)
        self.addSubview(cancelButton!)
        
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
