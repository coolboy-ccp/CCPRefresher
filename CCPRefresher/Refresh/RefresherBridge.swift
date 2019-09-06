//
//  RefresherBridge.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/5.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

private let CCPRefresherTopKey = UnsafeRawPointer(bitPattern: "CCPRefresherTopKey".hashValue)!
private let CCPRefresherBottomKey = UnsafeRawPointer(bitPattern: "CCPRefresherBottomKey".hashValue)!

private extension UIScrollView {
    var header: Refresher? {
        set {
            objc_setAssociatedObject(self, CCPRefresherTopKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, CCPRefresherTopKey) as? Refresher
        }
    }

    var footer: Refresher? {
        set {
            objc_setAssociatedObject(self, CCPRefresherBottomKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, CCPRefresherBottomKey) as? Refresher
        }
    }
}

public final class CCPBridge<T> {
    private let base: T
    init(_ base: T) {
        self.base = base
    }
}

public extension CCPBridge where T: UIScrollView {
    var top: Refresher? {
        return self.base.header
    }
    
    var bottom: Refresher? {
        return self.base.footer
    }
}



public protocol CCPRefresher {
    associatedtype CCPRefresherType
    var ccp: CCPRefresherType { get }
}

extension UIScrollView: CCPRefresher {
    public var ccp: CCPBridge<UIScrollView> {
        return CCPBridge.init(self)
    }
}

