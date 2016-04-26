//
//  PKBOAddPakiViewController.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOAddPakiViewController: UIViewController, PKBOSelectTimeDelegate, GMSMapViewDelegate, UITextFieldDelegate {


    var selectOpeningTimeVC: PKBOSelectTimeViewController?
    var selectClosingTimeVC: PKBOSelectTimeViewController?
    
    var newShop: PKBOShop = PKBOShop.shop()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentView = self.view as? PKBOAddPakiView
        
        currentView?.timeView?.openingTimeButton?.addTarget(self, action: "didUserSelectOpenTimeButton:", forControlEvents: .TouchUpInside)
        currentView?.timeView?.closingTimeButton?.addTarget(self, action: "didUserSelectClosingTimeButton:", forControlEvents: .TouchUpInside)
        
        let bolognaCamera = GMSCameraPosition.cameraWithLatitude(PKBOLocationPreference.PKBOBolognaLatitude, longitude: PKBOLocationPreference.PKBOBolognaLongitude, zoom: 12.0)
        
        currentView?.mapView!.camera = bolognaCamera
        currentView?.mapView?.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        currentView?.mapView?.delegate = self
        currentView?.nameTextField?.delegate = self
        
        currentView?.saveShopButton?.addTarget(self, action: "saveShop:", forControlEvents: .TouchUpInside)
        currentView?.cancelButton?.addTarget(self, action: "cancel:", forControlEvents: .TouchUpInside)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func didUserSelectOpenTimeButton(sender: UIButton)
    {
        let currentView = self.view as? PKBOAddPakiView
        
        currentView?.timeView?.userInteractionEnabled = false
        self.showOpeningTimeVC()
    }
    
    func didUserSelectClosingTimeButton(sender: UIButton)
    {
        let currentView = self.view as? PKBOAddPakiView
        
        currentView?.timeView?.userInteractionEnabled = false
        self.showClosingTimeVC()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView()
    {
        self.view = PKBOAddPakiView(frame: UIScreen.mainScreen().bounds)
    }
    
    
    private func showClosingTimeVC()
    {
        self.selectClosingTimeVC = PKBOSelectTimeViewController()
        self.selectClosingTimeVC?.selectDescription = "Select closing time."
        self.showTimeViewControllerWithVC(self.selectClosingTimeVC!)
    }
    
    private func showOpeningTimeVC()
    {
        self.selectOpeningTimeVC = PKBOSelectTimeViewController()
        self.selectOpeningTimeVC?.selectDescription = "Select opening time."
        self.showTimeViewControllerWithVC(selectOpeningTimeVC!)
    }
    
    private func showTimeViewControllerWithVC(viewController: PKBOSelectTimeViewController)
    {
        let currentView = self.view as? PKBOAddPakiView
        
        currentView?.nameTextField?.resignFirstResponder()
        
        viewController.delegate = self
        
        viewController.view.frame = CGRectMake(viewController.view.frame.origin.x, self.view.frame.size.height, viewController.view.frame.size.width, viewController.view.frame.size.height)
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.9,
            options: [],
            animations: { () -> Void in
                viewController.view.frame = CGRectMake(viewController.view.frame.origin.x, self.view.frame.size.height/3, viewController.view.frame.size.width, viewController.view.frame.size.height)
                
            }) { (finished) -> Void in
                
        }
    }
    
    
    private func dismissOpeningTimeVC()
    {
    
    }
    
    
    // MARK: - PKBOSelectTimeDelegate delegate methdos
    func didUserSelectTime(selectTimeViewController: PKBOSelectTimeViewController!)
    {
    }
    
    func didUserWantDismissSelectTimeViewController(selectTimeViewController: PKBOSelectTimeViewController!)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "HH:mm"
        
        let currentView = self.view as? PKBOAddPakiView
        
        let selectedTime = dateFormatter.stringFromDate(selectTimeViewController.time!)
        
        if(selectTimeViewController == self.selectOpeningTimeVC)
        {
            currentView?.timeView?.openingTime = selectedTime
            self.newShop.openingTime = selectedTime
        }
        
        if(selectTimeViewController == self.selectClosingTimeVC)
        {
            currentView?.timeView?.closingTime = selectedTime
            self.newShop.closingTime = selectedTime
        }
        
        selectTimeViewController.willMoveToParentViewController(self)
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.9,
            options: [],
            animations: { () -> Void in
            selectTimeViewController.view.frame = CGRectMake(selectTimeViewController.view.frame.origin.x, self.view.frame.size.height, selectTimeViewController.view.frame.size.width, selectTimeViewController.view.frame.size.height)
            
        }) { (finished) -> Void in
            selectTimeViewController.removeFromParentViewController()
            
            currentView?.timeView?.userInteractionEnabled = true
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        let customView = self.view as? PKBOAddPakiView
        let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            
        customView?.mapView?.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 20.0)
        
        customView?.mapView?.removeObserver(self, forKeyPath: "myLocation")
        
        self.newShop.coordinate = PFGeoPoint(location: myLocation)
    }
    
    
    // MARK: - GMSMapViewDelegate delegate methods
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!)
    {
        let positionLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        if(mapView.myLocation != nil)
        {
            let distance = mapView.myLocation.distanceFromLocation(positionLocation)
            if(distance <= PKBOLocationPreference.PKBOMaxDistanceFromBolognaLocation)
            {
                self.newShop.coordinate = PFGeoPoint(location: positionLocation)
            }
            else
            {
                //too far from current location
                mapView.camera = GMSCameraPosition.cameraWithTarget(mapView.myLocation.coordinate, zoom: 20.0)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate delegate methods
    func textFieldDidEndEditing(textField: UITextField)
    {
        let currentView = self.view as? PKBOAddPakiView
        
        if(textField == currentView?.nameTextField)
        {
            self.newShop.name = textField.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        let currentView = self.view as? PKBOAddPakiView
        
        currentView?.nameTextField?.resignFirstResponder()
    }
    
    func saveShop(sender: PKBOButton)
    {
        let currentView = self.view as? PKBOAddPakiView
        let userLocation = currentView?.mapView?.myLocation
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(self.newShop.coordinate.latitude, self.newShop.coordinate.longitude))
        { (response: GMSReverseGeocodeResponse!, error: NSError!) -> Void in
            if let unwrappedError = error
            {
                print("Error in reverse geolocalization. \(unwrappedError.localizedDescription)")
            }
            else
            {
                if response.firstResult() != nil
                {
                    if(response.firstResult().thoroughfare != nil)
                    {
                        self.newShop.thoroughfare = response.firstResult().thoroughfare
                    }
                    if(response.firstResult().country != nil)
                    {
                        self.newShop.country = response.firstResult().country
                    }
                    if(response.firstResult().postalCode != nil)
                    {
                        self.newShop.postalCode = response.firstResult().postalCode
                    }
                    if(response.firstResult().locality != nil)
                    {
                        self.newShop.locality = response.firstResult().locality
                    }
                
                    if(userLocation?.distanceFromLocation(PKBOLocationPreference.PKBOBolognaLocation) <= PKBOLocationPreference.PKBOMaxDistanceFromBolognaLocation)
                    {
                        self.newShop.saveInBackgroundWithBlock
                        { (saved: Bool, error: NSError?) -> Void in
                                self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                    else
                    {
                        // raise distance error
                    }
                }
            }
        }
    }
    
    func cancel(sender: UIButton)
    {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .Default
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
