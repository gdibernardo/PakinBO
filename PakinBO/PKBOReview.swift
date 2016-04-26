//
//  PKBOReview.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 18/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOReview: PFObject, PFSubclassing
{
    @NSManaged var reviewedBy: PKBOUser?
   
    @NSManaged var toShop: PKBOShop?
    
    @NSManaged var rate: NSNumber
    
    @NSManaged var comment: String
    
    
    static func review() -> PKBOReview
    {
        let review = PKBOReview()
        review.reviewedBy = PKBOUser.currentUser()
        
        return review
    }
    
    static func reviewWithRate(rate: Int, andComment comment: String) -> PKBOReview
    {
        let review = PKBOReview.review()
        review.rate = NSNumber(integer: rate)
        review.comment = comment
        
        return review
    }
    
    class func parseClassName() -> String
    {
        return "Review"
    }
    
}
