//
//  PKBOSearchBar.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 21/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

protocol PKBOSearchBarDelegate
{
    func didUserBackSearchBar(searchBar: PKBOSearchBar!)
    
    func didUserTypeInSearchBar(searchBar: PKBOSearchBar!, textInSearchBar: String)
    
    func didUserSearchInSearchBar(searchBar: PKBOSearchBar!)
    
    func didUserFocusOnSearchBar(searchBar: PKBOSearchBar!)
}

struct PKBOSearchBarPreferredContent
{
    
    
    private static let PKBOEdgeInset: CGFloat = 20.0
    
    private static let PKBOOriginY: CGFloat = 80.0
    
    static let PKBOOriginYSearch: CGFloat = 30.0
    
    private static let PKBOSearchBarHeight: CGFloat = 50.0
    
    static let PKBOSearchImageInset: CGFloat = 10.0
    
    static func preferredSearchBarFrameInMapFrame(frame: CGRect) -> CGRect
    {
        return CGRectMake(PKBOEdgeInset, PKBOOriginY, frame.size.width - PKBOEdgeInset * 2, PKBOSearchBarHeight)
    }
    
    static func preferredSearchBarFrameInSearchFrame(frame: CGRect) -> CGRect
    {
        return CGRectMake(PKBOEdgeInset, PKBOOriginYSearch, frame.size.width - PKBOEdgeInset * 2, PKBOSearchBarHeight)
    }
}

class PKBOSearchBar: UIButton, UITextFieldDelegate
{
    
    private var searchBarTextField: UITextField?
    
    private var backButton: UIButton?
    {
        didSet
        {
            backButton?.addTarget(self, action: "didUserTappedBackButton:", forControlEvents: .TouchUpInside)
        }
    }
    
    var text: String?
    {
        set
        {
            self.searchBarTextField?.text = newValue
        }
        get
        {
            return self.searchBarTextField?.text
        }
    }
    
    var delegate: PKBOSearchBarDelegate?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSizeMake(1, 4)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func mapSearchBar(frame:CGRect) -> PKBOSearchBar?
    {
        let searchBar = PKBOSearchBar(frame: frame)
        
        let imageView = UIImageView(frame: CGRectMake(searchBar.frame.size.width - PKBOSearchBarPreferredContent.PKBOSearchImageInset * 2 - 30, PKBOSearchBarPreferredContent.PKBOSearchImageInset, 30, 30))
        imageView.image = UIImage(named: "SearchIcon")
        
        searchBar.searchBarTextField =  UITextField(frame: CGRectMake(10, 10, frame.size.width - 60, frame.size.height - 20))
        searchBar.searchBarTextField?.textAlignment = .Left
        searchBar.searchBarTextField?.userInteractionEnabled = false
        
        searchBar.addSubview(searchBar.searchBarTextField!)
        

        searchBar.addSubview(imageView)
        
        return searchBar
    }
    
    
    static func searchViewSearchBar(frame:CGRect) -> PKBOSearchBar?
    {
        let searchBar = PKBOSearchBar(frame: frame)
        
        searchBar.backButton = UIButton(frame: CGRectMake(5, PKBOSearchBarPreferredContent.PKBOSearchImageInset, 30, 30))
        searchBar.backButton?.setImage(UIImage(named: "BackIcon"), forState: .Normal)
        
        searchBar.addSubview(searchBar.backButton!)
        
        searchBar.searchBarTextField = UITextField(frame: CGRectMake(40, 10, frame.size.width - 50, frame.size.height - 20))
        searchBar.searchBarTextField!.textAlignment = .Left
        searchBar.searchBarTextField!.placeholder = "Search"
        searchBar.addSubview(searchBar.searchBarTextField!)
        
        searchBar.searchBarTextField?.delegate = searchBar
        
        searchBar.addSubview(searchBar.searchBarTextField!)
        searchBar.searchBarTextField?.returnKeyType = UIReturnKeyType.Search
        
        return searchBar
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.delegate?.didUserSearchInSearchBar(self)
        
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let currentText = (self.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        self.delegate?.didUserTypeInSearchBar(self, textInSearchBar: currentText)
        return true
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        self.delegate?.didUserFocusOnSearchBar(self)
        return true
    }
    func focusOnSearchBar()
    {
        self.searchBarTextField?.becomeFirstResponder()
    }
    
    func releaseFocusOnSearchBar()
    {
        self.searchBarTextField?.resignFirstResponder()
    }
    
    func didUserTappedBackButton(sender: UIButton)
    {
        self.releaseFocusOnSearchBar()
        self.delegate?.didUserBackSearchBar(self)
    }
    
    func clearText()
    {
        self.text = " "
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
