//
//  PKBOMainViewController.swift
//  Paki In BO
//
//  Created by Gabriele Di Bernardo on 20/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

struct PKBOLocationPreference
{
    static let PKBOBolognaLatitude = 44.494288
    static let PKBOBolognaLongitude = 11.346374
    
    static let PKBOBolognaLocation = CLLocation(latitude: PKBOBolognaLatitude, longitude: PKBOBolognaLongitude)
    
    static let PKBOMaxDistanceFromBolognaLocation: CLLocationDistance = 10000
    static let PKBOMaxDistanceFromUserLocation: CLLocationDistance = 10
}




class PKBOMainViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, PKBOSearchAddressDelegate, PKBOShopDetailsDelegate
{
    private var shopMarkersDictionary: [String:PKBOMarker]?
    
    private let transitionManager = PKBOTransitionManager()
    
    private var didFindMyLocationAtStartUp = false
    
    private var isDetailsShopUnderneathVCPresented = false
    
    private var underneathDetailsShopVC: PKBOShopDetailsViewController?
    
    private var centerUserPositionButton: PKBOButton?
    {
        didSet
        {
            centerUserPositionButton?.addTarget(self, action: "centerUserInMap:", forControlEvents: .TouchUpInside)
        }
    }
    
    private var addPakiButton: PKBOButton?
    {
        didSet
        {
            addPakiButton?.addTarget(self, action: "addPaki:", forControlEvents: .TouchUpInside)
        }
    }
    
    
    private var directionToShopButton: PKBOButton?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        PKBOLocationManager.sharedInstance.delegate = self
        PKBOLocationManager.sharedInstance.requestWhenInUseAuthorization()
        
        let customView = self.view as? PKBOMainView
        
        let bolognaCamera = GMSCameraPosition.cameraWithLatitude(PKBOLocationPreference.PKBOBolognaLatitude, longitude: PKBOLocationPreference.PKBOBolognaLongitude, zoom: 12.0)
        
        customView?.mainMapView?.delegate = self
        customView?.mainMapView?.camera = bolognaCamera
        
        customView?.mainMapView?.addObserver(self, forKeyPath: "myLocation", options: .New, context: nil)
        
       
        
        let customButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        customButton.setImage(UIImage(named: "UserIcon"), forState: .Normal)
        customButton.addTarget(self, action: "showUserMenu:", forControlEvents: .TouchUpInside)
        
        let menuBarButtonItem = UIBarButtonItem(customView: customButton)
        
    
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
        
        customView?.searchBar?.addTarget(self, action: "searchBarDidPress:", forControlEvents: .TouchUpInside)
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.fetchAndPutOnMapAllShops()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView()
    {
        let customView = PKBOMainView(frame: UIScreen.mainScreen().bounds)
        
        self.view = customView
    }
    
    // MARK: - Location Manager delegate methods
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if(status == .AuthorizedWhenInUse)
        {
            let customView = self.view as? PKBOMainView
            
            customView?.mainMapView?.myLocationEnabled = true
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if(!didFindMyLocationAtStartUp)
        {
            let customView = self.view as? PKBOMainView
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            
            customView?.mainMapView?.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 13.0)
            
            didFindMyLocationAtStartUp = true
            
            self.centerUserPositionButton = PKBOButton.mapButton(PKBOButtonPreferredContent.preferredFrameForCenterUserButtonInFrame(self.view.frame), withType:.PKBOTypeMapCenterUserType)
            
            self.view.addSubview(self.centerUserPositionButton!)
            
            self.addPakiButton = PKBOButton.mapButton(PKBOButtonPreferredContent.preferredFrameForAddPakiButtonInFrame(self.view.frame), withType: PKBOType.PKBOTypeMapAddPakiType)
            
            self.view.addSubview(self.addPakiButton!)
            
            customView?.mainMapView?.removeObserver(self, forKeyPath: "myLocation")
        }
    }
    
    
    func centerUserInMap(sender: PKBOButton)
    {
        let customView = self.view as? PKBOMainView
        
        customView?.mainMapView?.animateToLocation(customView!.mainMapView!.myLocation.coordinate)
    }
    
    func addPaki(sender: PKBOButton)
    {
        let vc = PKBOAddPakiViewController()

        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func showUserMenu(sender: UIButton)
    {
        print("Bar menu pressed.")
    }
    
    func searchBarDidPress(sender: PKBOSearchBar)
    {
        let vc = PKBOSearchViewController()
        vc.delegate = self
        self.transitionManager.mode = .Search
        
        vc.transitioningDelegate = self.transitionManager
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - GMSMapViewDelegate delegate methods
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool
    {
        let shopMarker = marker as? PKBOMarker
        
        mapView.animateToLocation(shopMarker!.position)
        self.presentUnderneathShopDetailsViewControllerForShop(shopMarker?.shop!)
        
        return true
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D)
    {
        self.dismissUnderneathShopDetailsViewController()
    }
    
    private func removeAllMarkersFromMap()
    {
        if let shopsDictionary = self.shopMarkersDictionary
        {
            let keys = Array(shopsDictionary.keys)
            
            for(var index = 0; index < keys.count; index++)
            {
                let marker = self.shopMarkersDictionary![keys[index]]
                marker?.map = nil
            }
        }
    }
    
    
    private func fetchAndPutOnMapAllShops()
    {
        let currentView = self.view as? PKBOMainView
        PKBOShop.allShopsWithCompletionHandler { (shops: [AnyObject]?, error: NSError?) -> Void in
            if let unwrappedError = error
            {
            
            }
            else
            {
                if let unwrappedShops = shops
                {
                    self.removeAllMarkersFromMap()
                    self.shopMarkersDictionary = [String:PKBOMarker]()
                    
                    for(var index = 0; index < unwrappedShops.count; index++)
                    {
                        let currentShop = unwrappedShops[index] as? PKBOShop
                        let currentMarker = currentShop!.marker()
                        currentMarker.map = currentView?.mainMapView
                        
                        self.shopMarkersDictionary![currentShop!.objectId!] = currentMarker
                    }
                }
            }
            
        }
    }
    
    
    private func presentUnderneathShopDetailsViewControllerForShop(shop: PKBOShop!)
    {
        if(!isDetailsShopUnderneathVCPresented)
        {
            self.underneathDetailsShopVC = PKBOShopDetailsViewController.shopDetailsViewController(.PKBOShopDetailsModeUnderneathMode)
            self.underneathDetailsShopVC?.delegate = self
            self.underneathDetailsShopVC?.shop = shop
            let currentView = self.view as? PKBOMainView
            
            self.addChildViewController(self.underneathDetailsShopVC!)
            self.underneathDetailsShopVC!.view.frame = CGRectMake(self.underneathDetailsShopVC!.view.frame.origin.x, self.view.frame.size.height, self.underneathDetailsShopVC!.view.frame.size.width, self.underneathDetailsShopVC!.view.frame.size.height)
            currentView?.mainMapView?.addSubview(self.underneathDetailsShopVC!.view)
            self.underneathDetailsShopVC!.didMoveToParentViewController(self)
            
            self.directionToShopButton = PKBOButton.mapButton(CGRectMake(self.view.frame.size.width - PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.width - 10, self.underneathDetailsShopVC!.view.frame.origin.y - PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.height/2, PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.width, PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.height), withType: .PKBOTypeMapDirectionType)
            
            self.view.addSubview(self.directionToShopButton!)
            
            UIView.animateWithDuration(0.2,
                delay: 0.0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 0.2,
                options: [],
                animations:
                { () -> Void in
               
                    self.addPakiButton?.alpha = 0.0
                    
                    self.underneathDetailsShopVC!.view.frame = CGRectMake(self.underneathDetailsShopVC!.view.frame.origin.x, currentView!.mainMapView!.frame.size.height - self.underneathDetailsShopVC!.view.frame.size.height, self.underneathDetailsShopVC!.view.frame.size.width, self.underneathDetailsShopVC!.view.frame.size.height)
                    self.directionToShopButton!.frame = CGRectMake(self.view.frame.size.width - PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.width - 10, self.underneathDetailsShopVC!.view.frame.origin.y - PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.height/2, PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.width, PKBOButtonPreferredContent.PKBOMapButtonPreferredSize.height)
                    self.centerUserPositionButton?.frame = CGRectMake(self.centerUserPositionButton!.frame.origin.x, self.directionToShopButton!.frame.origin.y - self.centerUserPositionButton!.frame.size.height - 10, self.centerUserPositionButton!.frame.size.width, self.centerUserPositionButton!.frame.size.height)
                    
                }, completion: { (finished: Bool) -> Void in
                
                    self.addPakiButton?.hidden = true
                    
            })
            
            self.isDetailsShopUnderneathVCPresented = true
        }
        else
        {
            self.underneathDetailsShopVC?.changeShopWithShop(shop)
        }
    }
    
    
    private func dismissUnderneathShopDetailsViewController()
    {
        if(isDetailsShopUnderneathVCPresented)
        {
            let currentView = self.view as? PKBOMainView
            
            UIView.animateWithDuration(0.2,
                delay: 0.0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 0.2,
                options: [],
                animations: { () -> Void in
                    
                    self.underneathDetailsShopVC!.view.frame = CGRectMake(self.underneathDetailsShopVC!.view.frame.origin.x, self.view.frame.size.height, self.underneathDetailsShopVC!.view.frame.size.width, self.underneathDetailsShopVC!.view.frame.size.height)
                    self.directionToShopButton?.alpha = 0.0
                    self.addPakiButton?.hidden = false
                    self.addPakiButton?.alpha = 1.0
                    self.centerUserPositionButton?.frame = PKBOButtonPreferredContent.preferredFrameForCenterUserButtonInFrame(self.view.frame)
                },
                completion: { (finished: Bool) -> Void in
                    self.underneathDetailsShopVC?.view.removeFromSuperview()
                    self.underneathDetailsShopVC?.removeFromParentViewController()
                    self.didMoveToParentViewController(self)
                    self.directionToShopButton?.removeFromSuperview()
                    
                    
                    self.isDetailsShopUnderneathVCPresented = false
            })
        }
    }
    
    // MARK: - PKBOSearchAddressDelegate delegate methods
    func searchViewController(searchViewController: PKBOSearchViewController, didSelectAddress address: PKBOGeocoderAddress)
    {
        self.dismissUnderneathShopDetailsViewController()
        
        let currentView = self.view as? PKBOMainView
        
        currentView?.mainMapView?.camera = GMSCameraPosition.cameraWithTarget(address.coordinate!, zoom: 16.0)
        
        currentView?.searchBar?.text = address.formattedAddress
        
    }
    
    func searchViewControllerDidCancelSearch(searchViewController: PKBOSearchViewController)
    {
        let currentView = self.view as? PKBOMainView
        
        currentView?.searchBar?.clearText()
    }
    
    func shopDetailsViewControllerDidTapShop(shopDetailsViewController: PKBOShopDetailsViewController)
    {
       //      shopDetailsViewController.switchToMode(PKBOShopDetailsMode.PKBOShopDetailsModeFullScreenMode)
       self.presentFullyShopDetailsViewController()
    }
    
    
    func presentFullyShopDetailsViewController()
    {
        //self.underneathDetailsShopVC?.removeFromParentViewController()
       // self.underneathDetailsShopVC?.didMoveToParentViewController(self)
        let vc = PKBOShopDetailsViewController.shopDetailsViewController(.PKBOShopDetailsModeFullScreenMode)
        vc.shop = self.underneathDetailsShopVC?.shop
        self.presentViewController(vc, animated: true, completion: nil)
        //self.underneathDetailsShopVC?.view.frame.origin = CGPointMake(0, 0)
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
