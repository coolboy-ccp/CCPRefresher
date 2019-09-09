//
//  CCPRefresherBase.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/9.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

public let lastUpdateTimeKey = "CCPRefresher_lastUpdateTimeKey"

public enum FinishStyle: Int {
    case normal
    case nomore
}

public enum RefresherState: Int {
    case normal
    case willDo
    case doing
    case nomore
}

public enum Position: Int {
    case top
    case bottom
}

public enum RefresherStyle {
    case label
    case gif
}

public extension RefresherStyle {
    var top: RefresherCustomer {
        switch self {
        case .label:
            return LabelRefresher()
        case .gif:
            return GifRefresher()
        }
    }
    
    var bottom: RefresherCustomer {
        switch self {
        case .label:
            return LabelLoader()
        case .gif:
            return GifLoader()
        }
    }
}

public final class CCPBase<T> {
    internal let base: T
    init(_ base: T) {
        self.base = base
    }    
}

public protocol CCPRefresher {
    associatedtype CCPRefresherType
    var ccp: CCPRefresherType { get }
}

extension UIScrollView: CCPRefresher {
    public var ccp: CCPBase<UIScrollView> {
        return CCPBase(self)
    }
}

private let CCPRefresherTopKey = UnsafeRawPointer(bitPattern: "CCPRefresherTopKey".hashValue)!
private let CCPRefresherBottomKey = UnsafeRawPointer(bitPattern: "CCPRefresherBottomKey".hashValue)!

internal extension UIScrollView {
    var top: Refresher? {
        set {
            objc_setAssociatedObject(self, CCPRefresherTopKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, CCPRefresherTopKey) as? Refresher
        }
    }
    
    var bottom: Refresher? {
        set {
            objc_setAssociatedObject(self, CCPRefresherBottomKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, CCPRefresherBottomKey) as? Refresher
        }
    }
}
