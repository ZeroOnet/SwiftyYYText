//
//  UIView+Extensions.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

import UIKit

extension SYYable where Base: UIView {
    /// Returns the optional view's view controller.
    var viewController: UIViewController? {
        var nextResponder: UIResponder? = base.next
        while nextResponder != nil {
            if let result = nextResponder as? UIViewController { return result }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    /// Returns the visible alpha on screen, taking into account superview and window.
    var visibleAlpha: CGFloat {
        if let window = base as? UIWindow { return window.isHidden ? 0 : window.alpha }
        if base.window == nil { return 0 }
        var result: CGFloat = 1
        var view: UIView? = base
        while let aView = view {
            if aView.isHidden { result = 0; break }
            result *= aView.alpha
            view = aView.superview
        }
        return result
    }
}

extension SYYable where Base: UIView {
    /// Converts a point from the receiver's coordinate system to that of the specified view or window.
    /// - Parameters:
    ///   - point: A point specified in the local coordinate system (bounds) of the receiver.
    ///   - vow: The view or window into whose coordinate system point is to be converted.
    /// - Returns: The point converted to the coordinate system of view.
    func convert(_ point: CGPoint, toViewOrWindow vow: UIView) -> CGPoint {
        guard
            let from = base as? UIWindow ?? base.window,
            let to = vow as? UIWindow ?? vow.window,
            from != to
        else { return base.convert(point, to: vow) }
        var point = base.convert(point, to: from)
        point = to.convert(point, from: from)
        return vow.convert(point, from: to)
    }
    
    ///  Converts a point from the coordinate system of a given view or window to that of the receiver.
    /// - Parameters:
    ///   - point: A point specified in the local coordinate system (bounds) of view.
    ///   - vow: The view or window with point in its coordinate system.
    /// - Returns: The point converted to the local coordinate system (bounds) of the receiver.
    func convert(_ point: CGPoint, fromViewOrWindow vow: UIView) -> CGPoint {
        guard
            let from = vow as? UIWindow ?? vow.window,
            let to = base as? UIWindow ?? base.window,
            from != to
        else { return base.convert(point, from: vow) }
        var point = from.convert(point, from: vow)
        point = to.convert(point, from: from)
        return base.convert(point, from: to)
    }
    
    ///  Converts a rectangle from the receiver's coordinate system to that of another view or window.
    /// - Parameters:
    ///   - rect: A rectangle specified in the local coordinate system (bounds) of the receiver.
    ///   - vow: The view or window that is the target of the conversion operation.
    /// - Returns: The converted rectangle.
    func convert(_ rect: CGRect, toViewOrWindow vow: UIView) -> CGRect {
        guard
            let from = base as? UIWindow ?? base.window,
            let to = vow as? UIWindow ?? vow.window,
            from != to
        else { return base.convert(rect, to: vow) }
        var rect = base.convert(rect, to: from)
        rect = to.convert(rect, from: from)
        return vow.convert(rect, from: to)
    }
    
    ///  Converts a rectangle from the coordinate system of another view or window to that of the receiver.
    /// - Parameters:
    ///   - rect: A rectangle specified in the local coordinate system (bounds) of view.
    ///   - vow: The view or window with rect in its coordinate system.
    /// - Returns: The converted rectangle.
    func convert(_ rect: CGRect, fromViewOrWindow vow: UIView) -> CGRect {
        guard
            let from = vow as? UIWindow ?? vow.window,
            let to = base as? UIWindow ?? base.window,
            from != to
        else { return base.convert(rect, from: vow) }
        var rect = from.convert(rect, from: vow)
        rect = to.convert(rect, from: from)
        return base.convert(rect, from: to)
    }
}
