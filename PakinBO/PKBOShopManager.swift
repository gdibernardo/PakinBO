//
//  PKBOShopManager.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 27/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOShopManager: NSObject
{
    private static let instance = PKBOShopManager()
    
    static func sharedInstance() -> PKBOShopManager
    {
        return instance
    }
    
    private var shopsDictionary: [String:AnyObject]?
    
    
    func addShop(shop: PKBOShop)
    {
    
    }
    
    
}
