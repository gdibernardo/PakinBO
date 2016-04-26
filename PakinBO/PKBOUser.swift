//
//  PKBOUser.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 19/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

struct PKBOError
{
    static let PKBOErrorProfilePictureIsSilhouetteDomain = "Profile picture is silhouette domain."
    static let PKBOErrorProfilePictureIsSilhouetteCode = -1
    static let PKBOErrorProfilePictureIsSilhouetteLocalizedDescription = "Profile picture is silhouette. I did not set it to user."
}


class PKBOUser: PFUser
{
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    
    @NSManaged var facebookId: String?
    
    @NSManaged var birthday: NSDate?
    
    @NSManaged var isUserCompletelySignupped: Bool

    @NSManaged private var profilePicture: PFFile
    
    var picture: UIImage?
    {
        set
        {
            profilePicture = PFFile(name:"\(self.facebookId!)ProfilePicture.jpg",
                                    data:UIImageJPEGRepresentation(newValue!, 1.0)!)!
        }
        
        get
        {
           return UIImage(data: profilePicture.getData()!)
        }
    }
    
    
    func fetchFacebookProfilePictureWithCompletionHandler(completionHandler: (UIImage!, NSError!) -> Void )
    {
        /* Need to check if user is linked with Facebook */
        let parameters: [NSObject:AnyObject] = ["redirect":"false", "height":"200", "width":"200"]
        
        let request = FBSDKGraphRequest(graphPath:"/\(self.facebookId!)/picture", parameters:parameters)
        
        request.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
        
            if error != nil
            {
                completionHandler(nil, error)
            }
            else
            {
                if let pictureInfo = result.objectForKey("data") as? [NSObject:AnyObject]
                {
                    let isSilhouette = pictureInfo["is_silhouette"] as! Bool
                    if(isSilhouette)
                    {
                        let error = NSError(domain: PKBOError.PKBOErrorProfilePictureIsSilhouetteDomain,
                            code: PKBOError.PKBOErrorProfilePictureIsSilhouetteCode,
                            userInfo:[NSLocalizedDescriptionKey:PKBOError.PKBOErrorProfilePictureIsSilhouetteLocalizedDescription])
                        
                        completionHandler(nil, error)
                        
                    }
                    else
                    {
                        let imageURL = NSURL(string: pictureInfo["url"] as! String)
                        self.fetchImageAtURLWithCompletionHandler(imageURL!) { (image: UIImage!, error: NSError!) -> Void in
                           completionHandler(image, error)
                        }
                    }
                }
            }
        }
    }
    
    
    private func fetchImageAtURLWithCompletionHandler(imageURL: NSURL, completionHandler: (UIImage!, NSError!) -> Void)
    {
        let request = NSURLRequest(URL: imageURL)
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let downloadTask = session.downloadTaskWithRequest(request, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            if(error != nil)
            {
                completionHandler(nil, error)
            }
            else
            {
                let downloadedPicture = UIImage(data: NSData(contentsOfURL: location!)!, scale: 1.0)
                completionHandler(downloadedPicture, nil)
            }
        })
        
        downloadTask.resume()
    }
}
