//
//  PKBOWelcomeViewController.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 18/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit
import Parse




class PKBOWelcomeViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let currentView = self.view as! PKBOWelcomeView
        
        currentView.facebookLoginButton.addTarget(self, action: "performFacebookLogin", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func loadView()
    {
        let currentView = PKBOWelcomeView(frame: UIScreen.mainScreen().bounds)
        
        self.view = currentView
    }

    
    func performFacebookLogin()
    {
//        if let user = PKBOUser.currentUser()
//        {
//            let vc = PKBOPickUsernameViewController()
//            vc.uncompletelySignuppedUser = user
//            user.saveInBackground()
//            
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email","user_birthday"]) { (loggedUser:PFUser?, error: NSError?) -> Void in
            if let unwrappedError = error
            {
                    print("PKBOWelcomeViewController error logging Facebook. \(unwrappedError.localizedDescription)")
            }
            else
            {
                if let user:PKBOUser = loggedUser as? PKBOUser
                {
                    if(FBSDKAccessToken.currentAccessToken() != nil)
                    {
                       let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                        
                        request.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                            if error == nil
                            {
                                user.firstName = result["first_name"] as? String
                                user.lastName = result["last_name"] as? String
                                
                                user.email = result["email"] as? String
                                
                                user.facebookId = result["id"] as? String
                                
                                let birthdayDateFormatter = NSDateFormatter()
                                birthdayDateFormatter.dateFormat = "MM/dd/yyyy"
                                birthdayDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:result["timezone"] as! Int)
                                
                                user.birthday = birthdayDateFormatter.dateFromString(result["birthday"] as! String)
                                
                                user.saveInBackground()
                                
                                let vc = PKBOMainViewController()
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else
                            {
                                print("Error fetching user's Facebook data. \(error.localizedDescription)")
                            }
                       })
                    }
                   
                }
            }
        }
    }
    
//    
//    
//    
//    
//                        FBRequestConnection.startForMeWithCompletionHandler({ (connection:FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
//                                    if(error == nil)
//                                    {
//                                        user.firstName = result["first_name"] as? String
//                                        user.lastName = result["last_name"] as? String
//    
//                                        user.email = result["email"] as? String
//    
//                                        user.facebookId = result["id"] as? String
//    
//                                        let birthdayDateFormatter = NSDateFormatter()
//                                        birthdayDateFormatter.timeZone = NSTimeZone.systemTimeZone()
//                                        birthdayDateFormatter.dateFormat = "MM/dd/yyyy"
//                                        birthdayDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:result["timezone"] as! Int)
//    
//                                        user.birthday = birthdayDateFormatter.dateFromString(result["birthday"] as! String)
//    
//    //                                        if(user.isUserCompletelySignupped)
//    //                                        {
//    //                                            /* Show main view */
//    //                                        }
//    //                                        else
//    //                                        {
//    //                                            user.fetchFacebookProfilePictureWithCompletionHandler(){ (image: UIImage!, error: NSError!) -> Void in
//    //
//    //                                                if error != nil
//    //                                                {
//    //                                                    println("Error fetching Facebook profile picture. \(error.localizedDescription)")
//    //                                                }
//    //                                                else
//    //                                                {
//    //                                                    user.picture = image
//    //
//    //                                                    let vc = PKBOPickUsernameViewController()
//    //                                                    vc.uncompletelySignuppedUser = user
//    //                                                    user.saveInBackground()
//    //
//    //                                                    self.navigationController?.pushViewController(vc, animated: true)
//    //                                                }
//    //
//    //                                            }
//    //                                        }
//                                        user.saveInBackground()
//                                            /* Prepare for show main view */
//                                    }
//                                    else
//                                    {
//                                        /* Handle error. */
//                                    }
//                            } )

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
