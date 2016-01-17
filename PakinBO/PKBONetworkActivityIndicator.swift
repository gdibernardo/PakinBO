//
//  PKBONetworkActivityIndicator.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 06/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBONetworkActivityIndicator: NSObject
{
    private static let instance = PKBONetworkActivityIndicator()
    
    private var requestedActivities: Int = 0
    
    static func sharedInstance() -> PKBONetworkActivityIndicator
    {
        return instance
    }
    
    
    func show()
    {
        self.requestedActivities++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hide()
    {
        if(self.requestedActivities > 0)
        {
            self.requestedActivities--
            if(self.requestedActivities == 0)
            {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    
    func isShown() -> Bool
    {
        if(self.requestedActivities > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}
