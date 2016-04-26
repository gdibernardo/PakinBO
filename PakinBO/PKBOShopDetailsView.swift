//
//  PKBOShopDetailsView.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 31/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

private struct PKBOShopDetailsViewPreferredContent
{
    static let PKBOShopDetailsViewPrefferedSizeUnderneathSize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height/6)
    
    static let PKBOShopDetailsViewPrefferedLabelTopInset: CGFloat = 15.0
    static let PKBOShopDetailsViewPreferredLabelLeftInset: CGFloat = 10.0
    
}

class PKBOShopDetailsView: UIView
{

    var addressLabel: UILabel?
    var reviewsLabel: UILabel?
    
    var directionToShopButton: PKBOButton?
    
    var mapView: GMSMapView?
    
    var basicInfoView: UIView?
    
    var cancelButton: UIButton?
    
    var rateView: PKBOBeerRateView?
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSizeMake(1, 4)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func shopDetailsViewUnderneath() -> PKBOShopDetailsView
    {
        let shopDetailsView = PKBOShopDetailsView(frame: CGRectMake(0, 0, PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPrefferedSizeUnderneathSize.width, PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPrefferedSizeUnderneathSize.height))
        shopDetailsView.backgroundColor = UIColor.whiteColor()
        shopDetailsView.addressLabel = UILabel(frame: CGRectMake(PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPrefferedLabelTopInset, shopDetailsView.frame.size.width - 2*PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, shopDetailsView.frame.size.height/3))
        shopDetailsView.addressLabel?.textColor = UIColor.blackColor()
        
        shopDetailsView.addSubview(shopDetailsView.addressLabel!)
        
        shopDetailsView.reviewsLabel = UILabel(frame: CGRectMake(PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, shopDetailsView.frame.size.height - shopDetailsView.frame.size.height/3 - PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPrefferedLabelTopInset, shopDetailsView.frame.size.width - 2*PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset , shopDetailsView.frame.size.height/3))
        shopDetailsView.reviewsLabel?.text = "No reviews"
        shopDetailsView.reviewsLabel?.textColor = UIColor.blackColor()
        
        shopDetailsView.addSubview(shopDetailsView.reviewsLabel!)
        
        return shopDetailsView
    }
    
    static func shopDetailsViewFullScreen() -> PKBOShopDetailsView
    {
        let shopDetailsView = PKBOShopDetailsView(frame: UIScreen.mainScreen().bounds)
        
        shopDetailsView.backgroundColor = UIColor.whiteColor()
        
        shopDetailsView.mapView = GMSMapView(frame: CGRectMake(0, 0, shopDetailsView.frame.size.width, shopDetailsView.frame.size.height/3))
        shopDetailsView.addSubview(shopDetailsView.mapView!)
        shopDetailsView.mapView?.userInteractionEnabled = false
        
        shopDetailsView.basicInfoView = UIView(frame: CGRectMake(0, shopDetailsView.mapView!.frame.size.height, shopDetailsView.frame.size.width, shopDetailsView.frame.size.height/4))
        shopDetailsView.basicInfoView?.backgroundColor = UIColor.redColor()
        shopDetailsView.addSubview(shopDetailsView.basicInfoView!)
        
        shopDetailsView.directionToShopButton = PKBOButton.mapButton(CGRectMake(shopDetailsView.basicInfoView!.frame.size.width - PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.width - 10, shopDetailsView.basicInfoView!.frame.origin.y - PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.height/2, PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.width, PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.height), withType: .PKBOTypeMapDirectionType)
        shopDetailsView.addSubview(shopDetailsView.directionToShopButton!)

        shopDetailsView.cancelButton = UIButton(frame: CGRectMake(shopDetailsView.frame.size.width - 50, 25, 30, 30))
        shopDetailsView.cancelButton?.setImage(UIImage(named: "CancelIcon"), forState: .Normal)
        shopDetailsView.addSubview(shopDetailsView.cancelButton!)
        
        shopDetailsView.addressLabel = UILabel(frame: CGRectMake(PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, shopDetailsView.basicInfoView!.frame.size.width - 2 * PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, 50))
        shopDetailsView.addressLabel?.textColor = UIColor.whiteColor()
        
        shopDetailsView.basicInfoView!.addSubview(shopDetailsView.addressLabel!)
        
        shopDetailsView.rateView = PKBOBeerRateView(frame: CGRectMake(PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, 70, shopDetailsView.basicInfoView!.frame.size.width - 2 * PKBOShopDetailsViewPreferredContent.PKBOShopDetailsViewPreferredLabelLeftInset, 50))
        shopDetailsView.basicInfoView?.addSubview(shopDetailsView.rateView!)
        
        return shopDetailsView
    }
    
    
    func rearrangeForMode(mode: PKBOShopDetailsMode)
    {
        if(mode == PKBOShopDetailsMode.PKBOShopDetailsModeFullScreenMode)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
