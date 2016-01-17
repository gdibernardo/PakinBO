//
//  PKBOShop.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import Foundation

class PKBOShop: PFObject, PFSubclassing
{
    @NSManaged var name: String?
    
    @NSManaged var openingTime: String
    @NSManaged var closingTime: String
    
    @NSManaged var thoroughfare: String
    @NSManaged var locality: String
    @NSManaged var country: String
    @NSManaged var postalCode: String 
    
    @NSManaged var coordinate: PFGeoPoint
    
    @NSManaged var createdBy: PKBOUser?
    
    var formattedAddress: String
    {
        get
        {
            return "\(self.thoroughfare), \(self.postalCode), \(self.locality)"
        }
    }
    
    
    class func parseClassName() -> String
    {
        return "Shop"
    }
    
    static func shop() -> PKBOShop
    {
        let shop = PKBOShop()
        shop.createdBy = PKBOUser.currentUser()
        
        return shop
    }
    
    func marker() -> PKBOMarker
    {
        return PKBOMarker(shop: self)
    }
    
    func removeMarker()
    {
        
    }
    
    static func allShopsWithCompletionHandler(completionHandler: ([AnyObject]?, NSError?) -> Void)
    {
        let query = PKBOShop.query()
        
        query?.findObjectsInBackgroundWithBlock({ (shops: [AnyObject]?, error: NSError?) -> Void in
            completionHandler(shops, error)
        })
    }
    
    
    func allReview(completionHandler:([PKBOReview]?, NSError?) -> Void)
    {
        let query = PKBOReview.query()
        query?.whereKey("toShop", equalTo: self)
        
        query?.findObjectsInBackgroundWithBlock() { (result: [AnyObject]?, error: NSError?) -> Void in
            
            if let unwrappedError = error
            {
                completionHandler(nil, error)
            }
            else
            {
               // completionHandler(result as? [PKBOReview]a, error)
            }
        }
    }
}
