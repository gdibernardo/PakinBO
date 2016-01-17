//
//  PKBOCollectionViewLayout.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 03/06/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

private let layoutCellKind = "PKBOCollectionViewCell"

class PKBOCollectionViewLayout: UICollectionViewLayout
{
    var itemInsets: UIEdgeInsets?
    
    var itemSize: CGSize?
    
    var interItemSpacingY: CGFloat?
    
    var numberOfColumns: Int?
    
    private var layoutInfo: NSDictionary?
    
    override init()
    {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    
    private func setupLayout()
    {
        itemInsets = UIEdgeInsetsMake(100,20,10,20);
        itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - itemInsets!.left - itemInsets!.right, UIScreen.mainScreen().bounds.height/6)
        interItemSpacingY = 10.0;
        numberOfColumns = 1;
    }
    
    
    override func prepareLayout()
    {
        let newLayoutInfo = NSMutableDictionary()
        let cellLayoutInfo = NSMutableDictionary()
        
        let sectionCount = collectionView?.numberOfSections()
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        for(var section = 0; section < sectionCount; section++)
        {
            let itemCount = collectionView?.numberOfItemsInSection(section)
            for(var item = 0; item < itemCount; item++)
            {
                indexPath = NSIndexPath(forItem: item, inSection: section)
                
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame = frameForCellAtIndexPath(indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
            }
        }
        newLayoutInfo[layoutCellKind] = cellLayoutInfo
        layoutInfo = newLayoutInfo
    }
    
    
    private func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect
    {
        let row = indexPath.section / numberOfColumns!
        let column = indexPath.section % numberOfColumns!
        
        var currentIndexPath = NSIndexPath(forRow: row, inSection: column)
        
        
        var originY: CGFloat = 0.0
        let originX = floorf(Float(itemInsets!.left ))
        originY = floor(itemInsets!.top + (itemSize!.height + interItemSpacingY!) * CGFloat(row))
        
        return CGRectMake(CGFloat(originX), originY, itemSize!.width, itemSize!.height)
    }
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var allAttributes = [AnyObject]()
        
        layoutInfo?.enumerateKeysAndObjectsUsingBlock({ (elementIdentifier, elementsInfo, stop) -> Void in
            let info = elementsInfo as! NSDictionary
            info.enumerateKeysAndObjectsUsingBlock({(indexPath, attributes, innerStop) -> Void in
                if(CGRectIntersectsRect(rect, (attributes as! UICollectionViewLayoutAttributes).frame))
                {
                    allAttributes.append(attributes)
                }
            })
        })
        return allAttributes as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
    {
        return  (layoutInfo![layoutCellKind] as! NSDictionary)[indexPath] as! UICollectionViewLayoutAttributes
    }
    
    override func collectionViewContentSize() -> CGSize
    {
        let rowCount = collectionView!.numberOfSections() / numberOfColumns!
        let height = itemInsets!.top + (CGFloat(rowCount) * (itemSize!.height + interItemSpacingY!)) + itemInsets!.bottom
        
        return CGSizeMake(collectionView!.bounds.size.width, height)
    }

}
