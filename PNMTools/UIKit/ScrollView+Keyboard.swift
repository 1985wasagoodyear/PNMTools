//
//  ScrollView+Keyboard.swift
//  PNMTools
//
//  Created by K Y on 7/19/19.
//  Copyright © 2019 K Y. All rights reserved.
//

// MARK: - Sample, not usable.

import UIKit

open class ScrollableViewController: UIViewController {
    
    public var keyboardHeight: CGFloat = .zero
    
    public let animationDuration: TimeInterval = 0.3
    public var scrollView: UIScrollView!
    public var constraintContentHeight: NSLayoutConstraint!
    
    private var isAnimating = false
    private var lastOffset: CGPoint = .zero
    private var activeField: UITextView!
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard keyboardHeight == .zero,
            let activeField = activeField,
            let userInfo = sender.userInfo,
            let keyboardRect = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            else { return }
        keyboardHeight = keyboardRect.height
        
        // so increase contentView's height by keyboard height
        UIView.animate(withDuration: animationDuration, animations: {
            self.constraintContentHeight.constant += self.keyboardHeight
        })
        // move if keyboard hide input field
        let frame = activeField.frame
        let distanceToBottom = scrollView.frame.size.height - frame.origin.y - frame.size.height
        let collapseSpace = keyboardHeight - distanceToBottom
        if collapseSpace < 0 {
            // no collapse
            return
        }
        // set new offset for scroll view
        UIView.animate(withDuration: animationDuration, animations: {
            // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
        })
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: animationDuration) {
            self.constraintContentHeight.constant -= self.keyboardHeight
            self.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = 0.0
    }

}
