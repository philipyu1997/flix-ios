//
//  DismissAnimator.swift
//  Flix
//
//  Created by Philip Yu on 2/13/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class DismissAnimator : NSObject {
    
    guard
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
    let containerView = transitionContext.containerView()
    else {
    return
    }
    
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    }
}
