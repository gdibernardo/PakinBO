//
//  PKBOSearchViewController.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

private let PKBOCollectionViewReuseIdentifier = "PKBOReuseIdentifier"

private let PKBOTableViewReuseIdentifier = "PKBOTableViewReuseIdentifier"

protocol PKBOSearchAddressDelegate
{
    func searchViewController(searchViewController: PKBOSearchViewController, didSelectAddress address: PKBOGeocoderAddress)
    
    func searchViewControllerDidCancelSearch(searchViewController: PKBOSearchViewController)
}

class PKBOSearchViewController: UIViewController, PKBOSearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource
{

    private var searchResultsToDisplay: [PKBOGeocoderAddress]?
    
    var delegate: PKBOSearchAddressDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let currentView = self.view as? PKBOSearchView
        
        currentView?.shopCollectionView?.delegate = self
        currentView?.shopCollectionView?.dataSource = self
        
        currentView?.searchTableView?.delegate = self
        currentView?.searchTableView?.dataSource = self
        
        currentView?.shopCollectionView?.registerClass(PKBOCollectionViewCell.self,
            forCellWithReuseIdentifier: PKBOCollectionViewReuseIdentifier)
        currentView?.searchTableView?.registerClass(PKBOTableViewCell.self,
            forCellReuseIdentifier: PKBOTableViewReuseIdentifier)
        
        
        currentView?.searchBar?.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        animateSearchBarForAppear()
    }
    
   
    
    override func loadView()
    {
        self.view = PKBOSearchView(frame: UIScreen.mainScreen().bounds)
    }

    
    func dismissSearchViewController()
    {
        animateSearchBarForDisappearWithCompletionHandler()
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func animateSearchBarForAppear()
    {
        let currentView = self.view as! PKBOSearchView
        
        UIView.animateWithDuration(0.6,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            options:[],
            animations: { () -> Void in
                currentView.searchBar!.frame = PKBOSearchBarPreferredContent.preferredSearchBarFrameInSearchFrame(currentView.frame)
                currentView.shopCollectionView?.hidden = false
                currentView.shopCollectionView?.alpha = 1.0
        }) { (finished) -> Void in
            
                currentView.searchBar?.focusOnSearchBar()
        }
    }
    
    func animateSearchBarForDisappearWithCompletionHandler(completionHandler: (Void) -> Void)
    {
        let currentView = self.view as! PKBOSearchView
        
        UIView.animateWithDuration(0.6,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            options:[],
            animations: { () -> Void in
                currentView.searchBar!.frame = PKBOSearchBarPreferredContent.preferredSearchBarFrameInMapFrame(currentView.frame)
                currentView.shopCollectionView?.alpha = 0.0
                currentView.searchTableView?.alpha = 0.0
            }) { (finished) -> Void in
               currentView.shopCollectionView?.hidden = true
               currentView.searchTableView?.hidden = true
               completionHandler()
        }
    }

    
    
    // MARK: - PKBOSearchBarDelegate methods
    func didUserSearchInSearchBar(searchBar: PKBOSearchBar!)
    {
        print("User just performed a search")
    }
    
    func didUserBackSearchBar(searchBar: PKBOSearchBar!)
    {
        self.delegate?.searchViewControllerDidCancelSearch(self)
        
        self.dismissSearchViewController()
    }
    
    func didUserTypeInSearchBar(searchBar: PKBOSearchBar!, textInSearchBar: String)
    {
        let currentView = self.view as? PKBOSearchView
        if(textInSearchBar == "")
        {
            currentView?.disableSearchModeWithCompletionHandler(){}
            
            self.delegate?.searchViewControllerDidCancelSearch(self)
        }
        else
        {
            currentView?.enableSearchingModeWithCompletionHandler(){}
            
            PKBOGeocoder.sharedInstance().geocodeAddress(textInSearchBar) { (results: [PKBOGeocoderAddress]!, error: NSError!) -> Void in
                if(error != nil)
                {
                    return
                }
                self.searchResultsToDisplay = results
                currentView?.searchTableView?.reloadData()
            }
        }
    }
    
    func didUserFocusOnSearchBar(searchBar: PKBOSearchBar!)
    {
        
    }
    
    // MARK: - UIScrollViewDelegate methods
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let currentView = self.view as! PKBOSearchView
        
        currentView.searchBar?.releaseFocusOnSearchBar()
    }
    // MARK: - UICollectionViewDelegate methods

    
    // MARK: - UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PKBOCollectionViewReuseIdentifier, forIndexPath: indexPath) as! PKBOCollectionViewCell
        
        return cell
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        let currentView = self.view as? PKBOSearchView
        
        currentView?.searchBar?.releaseFocusOnSearchBar()
    }
    
    
    // MARK: - UITableViewDataSource delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let unwrappedResults = self.searchResultsToDisplay
        {
            return unwrappedResults.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(PKBOTableViewReuseIdentifier, forIndexPath: indexPath) as! PKBOTableViewCell
        cell.textLabel?.text = self.searchResultsToDisplay![indexPath.row].formattedAddress
        return cell
    }
    
    
    // MARK: - UITableViewDelegate delegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedAddress = self.searchResultsToDisplay![indexPath.row]
        
        self.delegate?.searchViewController(self, didSelectAddress: selectedAddress)
        
        self.dismissSearchViewController()
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
