//
//  PKBOGeocoderAddress.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 06/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOGeocoderAddress: NSObject
{
    var route: String?
    var locality: String?
    var country: String?
    var formattedAddress: String?
    
    var coordinate: CLLocationCoordinate2D?
    
    static func address() -> PKBOGeocoderAddress
    {
        return PKBOGeocoderAddress()
    }
}
