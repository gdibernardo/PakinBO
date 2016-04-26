//
//  PKBOSearchView.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 26/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

class PKBOSearchView: UIView
{

    var searchBar: PKBOSearchBar?

    var shopCollectionView: UICollectionView?
    
    var searchTableView: UITableView?
    
    var isSearchModeEnabled: Bool = false
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.shopCollectionView = UICollectionView(frame: CGRectMake(0, PKBOSearchBarPreferredContent.PKBOOriginYSearch, frame.size.width, frame.size.height - PKBOSearchBarPreferredContent.PKBOOriginYSearch), collectionViewLayout: PKBOCollectionViewLayout())
        self.shopCollectionView?.backgroundColor = UIColor.clearColor()
        self.shopCollectionView?.hidden = true
        self.shopCollectionView?.alpha = 0.0
        
        self.searchTableView = UITableView(frame: CGRectMake(20, PKBOSearchBarPreferredContent.PKBOOriginYSearch, frame.size.width - 40 , frame.size.height - PKBOSearchBarPreferredContent.PKBOOriginYSearch), style: .Plain)
        self.searchTableView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        self.searchTableView?.hidden = true
        self.searchTableView?.alpha = 0.0
        self.searchTableView?.tableFooterView = UIView(frame: CGRectZero)
        self.searchTableView?.tableHeaderView = UIView(frame: CGRectZero)
        self.searchTableView?.separatorStyle = .None
        
        self.addSubview(self.shopCollectionView!)
        
        self.addSubview(self.searchTableView!)
        
        searchBar = PKBOSearchBar.searchViewSearchBar(PKBOSearchBarPreferredContent.preferredSearchBarFrameInMapFrame(frame))
        
        self.addSubview(searchBar!)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableSearchingModeWithCompletionHandler(completionHandler: () -> Void)
    {
        if(!self.isSearchModeEnabled)
        {
            self.isSearchModeEnabled = true
            
            UIView.animateWithDuration(0.2,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: [],
                animations: { () -> Void in
                    self.shopCollectionView?.alpha = 0.0
                    self.searchTableView?.hidden = false
                    self.searchTableView?.alpha = 1.0
                }) { (finished: Bool) -> Void in
                    self.shopCollectionView?.hidden = true
                    completionHandler()
            }
        }
    }
    
    func disableSearchModeWithCompletionHandler(completionHandler: () -> Void)
    {
        if(self.isSearchModeEnabled)
        {
            self.isSearchModeEnabled = false
            UIView.animateWithDuration(0.2,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: [],
                animations: { () -> Void in
                    self.searchTableView?.alpha = 0.0
                    self.shopCollectionView?.alpha = 1.0
                    self.shopCollectionView?.hidden = false
                }) { (finished: Bool) -> Void in
                    self.searchTableView?.hidden = true
                    completionHandler()
            }
            
        }
    }
    
}
