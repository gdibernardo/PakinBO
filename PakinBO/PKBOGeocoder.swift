//
//  PKBOGeocoder.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 03/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit
import Foundation


class PKBOGeocoder: NSObject
{
    private static let singleGeocoderInstance = PKBOGeocoder()
    
    private var cache = [PKBOGeocoderAddress]()
    
    private static func queryWithAddress(address address: String) -> String
    {
        var formattedAddress = address + ", Bologna"
        formattedAddress = formattedAddress.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return "https://maps.googleapis.com/maps/api/geocode/json?address=\(formattedAddress)&region=it"
    }
    
    private static func globalQueue() -> dispatch_queue_t
    {
        return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
    }
    
    static func sharedInstance() -> PKBOGeocoder
    {
        return singleGeocoderInstance
    }
    
    
    func emptyCache()
    {
        self.cache = [PKBOGeocoderAddress]()
    }
    
    private func saveInCache(address: PKBOGeocoderAddress)
    {
        let checkArray = self.cache.filter { (cacheAddress: PKBOGeocoderAddress) -> Bool in
            (cacheAddress.coordinate?.latitude == address.coordinate?.latitude && cacheAddress.coordinate?.longitude == cacheAddress.coordinate?.longitude)
        }
        if checkArray.isEmpty
        {
            self.cache.append(address)
            self.cache.sortInPlace { (firstElement: PKBOGeocoderAddress, secondElement: PKBOGeocoderAddress) -> Bool in
                firstElement.formattedAddress!.localizedCaseInsensitiveCompare(secondElement.formattedAddress!) == NSComparisonResult.OrderedAscending
            }
        }
    }
    
    
    private func searchInCache(address address: String) -> [PKBOGeocoderAddress]
    {
        let cacheResults = self.cache.filter
        { (cacheAddress: PKBOGeocoderAddress) -> Bool in
            cacheAddress.formattedAddress!.containsIgnoringCase(address)
        }
        return cacheResults
    }
    
    
    func geocodeAddress(address: String, withCompletionHandler completionHandler: ([PKBOGeocoderAddress]!, NSError!) -> Void)
    {
        let query = PKBOGeocoder.queryWithAddress(address: address)
        
        /* Check in cache first. */
        let cacheResults = self.searchInCache(address: address)
        if(cacheResults.count > 0)
        {
            completionHandler(cacheResults,nil)
            return
        }
        self.geocodeWithQuery(query)
            { (result: NSData?) -> Void in
                if let unwrappedResult = result
                {
                    
                    let error: NSError?
                    
                    let jsonDictionary: NSDictionary?
                    do
                    {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedResult, options: []) as? NSDictionary
                    } catch _
                    {
                        jsonDictionary = nil
                    }
                    
                    
//                      let jsonDictionary = NSJSONSerialization.JSONObjectWithData(unwrappedResult,
//                      options: []) as? NSDictionary
                    
//                    if let unwrappedError = error
//                    {
//                        /* JSON serialization error. */
//                        completionHandler(nil, unwrappedError)
//                    }
                    var addressResults = [PKBOGeocoderAddress]()
                    var results = jsonDictionary!["results"] as? [AnyObject]
                    for index in 0 ..< results!.count
                    {
                        let types = results![index].objectForKey("types") as? [String]
                        if((types!).contains("route"))
                        {
                            let address = PKBOGeocoderAddress.address()
                            
                            let addressComponents = results![index].objectForKey("address_components") as? [AnyObject]
                            for(var component = 0; component < addressComponents!.count; component++)
                            {
                                let currentComponent = addressComponents![component] as! NSDictionary
                                let currentTypes = currentComponent["types"] as! [String]
                                
                                if(currentTypes.contains("route"))
                                {
                                    address.route = currentComponent["long_name"] as? String
                                }
                                
                                if(currentTypes.contains("locality"))
                                {
                                    address.locality = currentComponent["long_name"] as? String
                                }
                                
                                if(currentTypes.contains("country"))
                                {
                                    address.country = currentComponent["long_name"] as? String
                                }
                                
                            }
                            
                            address.formattedAddress = results![index].objectForKey("formatted_address") as? String
                            let location = (results![index].objectForKey("geometry") as? NSDictionary)!["location"] as? NSDictionary
                            let latitude = location!["lat"] as! CLLocationDegrees
                            let longitude = location!["lng"] as! CLLocationDegrees
                            
                            address.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                            
                            self.saveInCache(address)
                            addressResults.append(address)
                        }
                    }
                    completionHandler(addressResults,nil)
                }
        }
    }
    
    
    private func geocodeWithQuery(query: String, andCompletionHandler completionHandler: (NSData?) -> Void )
    {
        let queue = PKBOGeocoder.globalQueue()

        PKBONetworkActivityIndicator.sharedInstance().show()
        
        dispatch_async(queue, { () -> Void in
            let data = NSData(contentsOfURL: NSURL(string: query)!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
                PKBONetworkActivityIndicator.sharedInstance().hide()
                
                completionHandler(data)
            })
        })
    }
    
}




extension String
{
    func containsIgnoringCase(string: String) -> Bool
    {
        var start = self.startIndex
        repeat
        {
            let substring = self[Range(start: start++, end: endIndex)].lowercaseString
            if(substring.hasPrefix(string.lowercaseString))
            {
                return true
            }
        } while (start != self.endIndex)
        
        return false
    }
}
