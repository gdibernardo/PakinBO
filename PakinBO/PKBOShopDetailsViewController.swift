//
//  PKBOShopDetailsViewController.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 28/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

enum PKBOShopDetailsMode
{
    case PKBOShopDetailsModeUnderneathMode
    case PKBOShopDetailsModeFullScreenMode
}

protocol PKBOShopDetailsDelegate
{
    func shopDetailsViewControllerDidTapShop(shopDetailsViewController: PKBOShopDetailsViewController)
}

class PKBOShopDetailsViewController: UIViewController
{

    private var mode: PKBOShopDetailsMode?
    
    var shop: PKBOShop?
    
    var delegate: PKBOShopDetailsDelegate?
    
    static func shopDetailsViewController(mode: PKBOShopDetailsMode) -> PKBOShopDetailsViewController
    {
        let vc = PKBOShopDetailsViewController()
        vc.mode = mode
        
        return vc
    }
    
    func changeShopWithShop(shop: PKBOShop!)
    {
        self.shop = shop
        
        let currentView = self.view as? PKBOShopDetailsView
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2,
            options: [],
            animations: { () -> Void in
                
                currentView?.addressLabel?.text = self.shop?.formattedAddress
                
            }) { (finished: Bool) -> Void in
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentView = self.view as? PKBOShopDetailsView
        
        currentView?.addressLabel?.text = self.shop?.formattedAddress
        
        let marker = shop?.marker()
        marker?.map = currentView?.mapView
        
        currentView?.mapView?.camera = GMSCameraPosition.cameraWithTarget(marker!.position, zoom: 16.0)
        
        currentView?.cancelButton?.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView()
    {
        if(self.mode == .PKBOShopDetailsModeUnderneathMode)
        {
            self.view = PKBOShopDetailsView.shopDetailsViewUnderneath()
        }
        else
        {
            self.view = PKBOShopDetailsView.shopDetailsViewFullScreen()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if self.mode == .PKBOShopDetailsModeUnderneathMode
        {
            delegate?.shopDetailsViewControllerDidTapShop(self)
        }
    }

    func switchToMode(mode: PKBOShopDetailsMode)
    {
        let currentView = self.view as? PKBOShopDetailsView
       
        currentView?.rearrangeForMode(mode)
        
        self.mode = mode
    }
    
    func dismiss(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
