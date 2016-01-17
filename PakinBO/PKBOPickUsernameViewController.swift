//
//  PKBOPickUsernameViewController.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 20/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOPickUsernameViewController: UIViewController {
    
    var uncompletelySignuppedUser: PKBOUser?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let currentView = self.view as? PKBOPickUsernameView
        
        currentView?.profilePictureImageView.image = uncompletelySignuppedUser?.picture
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func loadView()
    {
        let customView = PKBOPickUsernameView(frame: UIScreen.mainScreen().bounds)
        
        self.view = customView
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        let currentView = self.view as? PKBOPickUsernameView
        
        currentView?.usernameTextField.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
