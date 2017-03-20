//
//  SSPushAnimator.swift
//  MyLabel
//
//  Created by SayOne on 22/11/16.
//  Copyright © 2016 SayOne. All rights reserved.
//

import UIKit
let kSnapShotPushDuration = 0.35
class SSPushAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kSnapShotPushDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let container: UIView = transitionContext.containerView
        
        let viewSize: CGSize = fromViewController.view.bounds.size
        let topFrame: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height/2)
        let bottomFrame: CGRect = CGRect(x: 0, y: viewSize.height/2, width: viewSize.width, height: viewSize.height/2)
        
        let viewTopSnapshot: UIView = fromViewController.view.resizableSnapshotView(from: topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
        let viewBottomSnapshot: UIView = fromViewController.view.resizableSnapshotView(from: bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
        viewTopSnapshot.frame = topFrame
        viewBottomSnapshot.frame = bottomFrame
        
        fromViewController.view.removeFromSuperview()
        
        container.addSubview(toViewController.view)
        container.addSubview(viewTopSnapshot)
        container.addSubview(viewBottomSnapshot)
        
        UIView.animate(withDuration: kSnapShotPushDuration, animations: {
            var newTopFrame: CGRect = topFrame
            var newBottomFrame: CGRect = bottomFrame
            
            newTopFrame.origin.y -= topFrame.size.height
            newBottomFrame.origin.y += bottomFrame.size.height
            
            viewTopSnapshot.frame = newTopFrame
            viewBottomSnapshot.frame = newBottomFrame
        }, completion: { finished in
            viewBottomSnapshot.removeFromSuperview()
            viewTopSnapshot.removeFromSuperview()
            
            transitionContext.completeTransition(finished)
        })
    }
}

class SSPopAnimator: NSObject,UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return kSnapShotPushDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    
    let container: UIView = transitionContext.containerView
    
    let viewSize: CGSize = fromViewController.view.bounds.size
    let topFrame: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height/2)
    let bottomFrame: CGRect = CGRect(x: 0, y: viewSize.height/2, width: viewSize.width, height: viewSize.height/2)
    let snapShot: UIView = toViewController.view.snapshotView(afterScreenUpdates: true)!
    let viewTopSnapshot: UIView = snapShot.resizableSnapshotView(from: topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
    let viewBottomSnapshot: UIView = snapShot.resizableSnapshotView(from: bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
    
    var offsetTopFrame: CGRect = topFrame
    var offsetBottomFrame: CGRect = bottomFrame
    
    offsetTopFrame.origin.y -= topFrame.size.height
    offsetBottomFrame.origin.y += bottomFrame.size.height
    
    viewTopSnapshot.frame = offsetTopFrame
    viewBottomSnapshot.frame = offsetBottomFrame
    
    container.addSubview(viewTopSnapshot)
    container.addSubview(viewBottomSnapshot)
    
    UIView.animate(withDuration: kSnapShotPushDuration, animations: {
      viewTopSnapshot.frame = topFrame
      viewBottomSnapshot.frame = bottomFrame
    }, completion: { finished in
      viewTopSnapshot.removeFromSuperview()
      viewBottomSnapshot.removeFromSuperview()
      fromViewController.view.removeFromSuperview()
      container.addSubview(toViewController.view)
      transitionContext.completeTransition(finished)
      
    })
    
  }
}

