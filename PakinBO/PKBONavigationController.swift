//
//  PKBONavigationController.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 20/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBONavigationController: UINavigationController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(rootViewController: UIViewController)
    {
        super.init(rootViewController: rootViewController)
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = UIColor.redColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
}
