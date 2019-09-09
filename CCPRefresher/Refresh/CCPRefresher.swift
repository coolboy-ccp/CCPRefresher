//
//  CCPRefresher.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/6.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

public typealias VoidClosure = () -> ()

public protocol RefresherHandler {
    func refreshing()
}

public extension CCPBase where T: UIScrollView {
    var top: Refresher? {
        return self.base.top
    }
    
    var bottom: Refresher? {
        return self.base.bottom
    }
    
    @discardableResult
    func refresh(style: RefresherStyle = .label, delegate: RefresherHandler) -> Refresher {
        return refresh(style: style) {
            delegate.refreshing()
        }
    }
    
    @discardableResult
    func autoRefresh(style: RefresherStyle = .label, delegate: RefresherHandler) -> Refresher {
        let refresher = refresh(style: style, delegate: delegate)
        refresher.begin()
        return refresher
    }
    
    @discardableResult
    func autoRefresh(style: RefresherStyle = .label, callback: VoidClosure? = nil) -> Refresher {
        let refresher = refresh(style: style, callback: callback)
        refresher.begin()
        return refresher
    }
    
    @discardableResult
    func refresh(style: RefresherStyle = .label, callback: VoidClosure? = nil) -> Refresher {
        if let refsher = top {
            return refsher
        }
        let refresher = Refresher(base, style.top, callback)
        base.top = refresher
        base.addSubview(refresher)
        return refresher
    }
    
    @discardableResult
    func loadMore(style: RefresherStyle = .label, callback: VoidClosure? = nil) -> Refresher {
        if let loader = bottom {
            return loader
        }
        let loader = Refresher(base, style.bottom, callback)
        base.bottom = loader
        base.addSubview(loader)
        return loader
    }
    
    @discardableResult
    func atuoLoadMore(style: RefresherStyle = .label, callback: VoidClosure? = nil) -> Refresher {
        let loader = loadMore(style: style, callback: callback)
        loader.begin()
        return loader
    }
    
    @discardableResult
    func loadMore(style: RefresherStyle = .label, delegate: RefresherHandler) -> Refresher {
        let loader = loadMore(style: style) {
            delegate.refreshing()
        }
        return loader
    }
    
    @discardableResult
    func autoLoadMore(style: RefresherStyle = .label, delegate: RefresherHandler) -> Refresher {
        let loader = loadMore(style: style, delegate: delegate)
        loader.begin()
        return loader
    }
}




