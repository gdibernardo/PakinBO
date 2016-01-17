//
//  PKBOMarker.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 27/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOMarker: GMSMarker
{
    var shop: PKBOShop?
    
    init(position: CLLocationCoordinate2D)
    {
        super.init()
        self.position = CLLocationCoordinate2DMake(position.latitude, position.longitude)
        self.icon = self.prepareForMarker(imageIcon: UIImage(named: "RedMarker")!)
    }
    
    convenience init(shop: PKBOShop)
    {
        let coordinate = CLLocationCoordinate2DMake(shop.coordinate.latitude, shop.coordinate.longitude)
        self.init(position: coordinate)
        
        self.shop = shop
    }
    
    private func prepareForMarker(imageIcon imageIcon: UIImage) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35.0, 35.0), false, 0.0)
        imageIcon.drawInRect(CGRectMake(0.0, 0.0, 35.0, 35.0))
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
}

