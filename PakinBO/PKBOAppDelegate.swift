//
//  AppDelegate.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 18/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit
import ParseUI
import Bolts
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class PKBOAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
     
        PKBOUser.registerSubclass()
        PKBOShop.registerSubclass()
        PKBOReview.registerSubclass()
        
        Parse.setApplicationId("8MQlptPksIcOCknOpx0eJZxgy68Gsd7IyQlAmDC0", clientKey:"nykpv01ACfAhe9QIodz0nup5RHiKGRWRENCb0CCH")
       
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        GMSServices.provideAPIKey("AIzaSyBgjFdFa5DFrd6htmrATS-WOtQwGOJvO_8")
        
        
        if let currentUser = PKBOUser.currentUser()
        {
            /* Prepare main view. */
            let mainVC = PKBOMainViewController()
            
            let nvc = PKBONavigationController(rootViewController: mainVC)
            
            window?.rootViewController = nvc
        }
        else
        {
            let welcomeViewController = PKBOWelcomeViewController()
         
            let nvc = PKBONavigationController(rootViewController: welcomeViewController)
            
            window?.rootViewController = nvc
        }
        
        window?.makeKeyAndVisible()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                            openURL: url,
                                                  sourceApplication: sourceApplication,
                                                         annotation: annotation)
    }


}

