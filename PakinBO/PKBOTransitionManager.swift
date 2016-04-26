//
//  PKBOTransitionManager.swift
//  PakinBO
//
//  Created by Gabriele Di Bernardo on 23/05/15.
//  Copyright (c) 2015 Gabriele Di Bernardo. All rights reserved.
//

import UIKit

enum PKBOTransitionManagerMode
{
    case Search
    case Shop
}

class PKBOTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate
{

    var mode: PKBOTransitionManagerMode?
    // MARK: - UIViewControllerAnimatedTransitioning delegate methods
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        containerView!.addSubview(fromView)
        containerView!.addSubview(toView)
        
        let duration = self.transitionDuration(transitionContext)
        
        switch(self.mode!)
        {
        case .Search:
            UIView.animateWithDuration(duration, animations: { () -> Void in
                fromView.alpha = 0.0
                toView.alpha = 1.0
                })
                { (finished) -> Void in
                    transitionContext.completeTransition(finished)
            }
        case .Shop:
            UIView.animateWithDuration(duration, animations: { () -> Void in
                fromView.alpha = 0.0
                toView.alpha = 1.0
                })
                { (finished) -> Void in
                    transitionContext.completeTransition(finished)
            }
            
        }
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.2
    }
    
    
    // MARK: - UIVIewControllerTransitioningDelegate delegate methods
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }
    
}
