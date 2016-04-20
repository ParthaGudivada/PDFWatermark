//
//  UIView.swift
//   
//
//  Created by Partha Gudivada on 3/1/16.
//  Copyright © 2016 Diligent. All rights reserved.
//

import UIKit



// Convenience functions help to reduce the boiler plate code while definining the constraints

public extension UIView {
    
    ///  Center a child View within given parentView in **X** Direction
    ///
    ///- parameter childView:            view that need to be centered
    ///- parameter withinParentView:     view that need to be the base view in which the childView need to be centered
    ///
    func centerX(childView: UIView, withinParentView parentView: UIView) {
        parentView.addConstraint(NSLayoutConstraint(item: childView, attribute: .CenterX, relatedBy: .Equal, toItem: parentView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
    }
    
    
    ///  Center a child View within given parentView in **Y** Direction
    ///
    ///- parameter childView:            view that need to be centered
    ///- parameter withinParentView:     view that need to be the base view in which the childView need to be centered
    ///
    func centerY(childView: UIView, withinParentView parentView: UIView) {
        parentView.addConstraint(NSLayoutConstraint(item: childView, attribute: .CenterY, relatedBy: .Equal, toItem: parentView, attribute: .CenterY, multiplier: 1.0, constant: 0))
    }
    
    /// Set the **width** of the view to the specific length
    ///
    ///- parameter toLength:            the length to which the view need to be set to
    ///
    func constrainWidthTo(length: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: length))
    }
    
    /// Set the **height** of the view to the specific length
    ///
    ///- parameter toLength:            the length to which the view need to be set to
    ///
    func constrainHeightTo(length: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: length))
    }
    
    ///  Expand the child view to fully occupy the parent view in **Horizontal** direction
    ///
    ///- parameter childView:       view that need to be expanded in the horizontal direction
    ///- parameter toParentView:    view to which the childView need to be  expanded
    ///
    func expandWidthOf(childView: UIView, toParentView parentView: UIView) {
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[childView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["childView": childView, "parentView": parentView]))
    }
    
    ///  Expand the child view to fully occupy the parent view in **Vertical** direction
    ///
    ///- parameter childView:       view that need to be expanded in the vertical direction
    ///- parameter toParentView:    view to which the childView need to be  expanded
    ///
    func expandHeightOf(childView: UIView, toParentView parentView: UIView) {
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[childView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["childView": childView, "parentView": parentView]))
    }
}
