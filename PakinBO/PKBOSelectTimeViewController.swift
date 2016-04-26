//
//  PKBOSelectTimeViewController.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

protocol PKBOSelectTimeDelegate
{
    func didUserSelectTime(selectTimeViewController: PKBOSelectTimeViewController!)
    
    func didUserWantDismissSelectTimeViewController(selectTimeViewController: PKBOSelectTimeViewController!)
}

class PKBOSelectTimeViewController: UIViewController {

    var delegate: PKBOSelectTimeDelegate?
    
    var selectDescription: String?
    {
        set
        {
            let currentView = self.view as? PKBOSelectTimeView
            currentView?.descriptionLabel?.text = newValue
        }
        get
        {
            let currentView = self.view as? PKBOSelectTimeView
            return currentView?.descriptionLabel?.text
        }
    }
    
    var time: NSDate?
    {
        set
        {
            if newValue != nil
            {
                let currentView = self.view as? PKBOSelectTimeView
            
                currentView?.timePicker?.date = newValue!
            }
        }
        get
        {
            let currentView = self.view as? PKBOSelectTimeView
            
            return currentView?.timePicker?.date
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentView = self.view as? PKBOSelectTimeView
        
        currentView?.timePicker?.addTarget(self, action: "didUserSelectTime:", forControlEvents:.ValueChanged)
        currentView?.dismissButton?.addTarget(self, action: "didUserTapDismissButton:", forControlEvents: .TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func loadView()
    {
        self.view = PKBOSelectTimeView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/3, UIScreen.mainScreen().bounds.size.width, (UIScreen.mainScreen().bounds.size.height/3) * 2))
    }

    func didUserSelectTime(sender: UIDatePicker)
    {
        delegate?.didUserSelectTime(self)
    }
    
    func didUserTapDismissButton(sender: UIButton)
    {
        delegate?.didUserWantDismissSelectTimeViewController(self)
    }
    
    convenience init(time: NSDate)
    {
        self.init()
        
        self.time = time
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
