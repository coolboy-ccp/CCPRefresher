//
//  RefresherHeader.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit


class RefresherHeader: RefresherBase {
    
    //理论上不可能有vc == nil的情况
    private lazy var lastRefreshTimeKey: String = {
        guard let vc = self.vc else {
            return "lastRefreshTimeKey"
        }
        return "lastRefreshTimeKey\(type(of: vc))"
    }()
    
    public var lastRefreshTime: Date {
        
    }
    
    
    override func prepare() {
        super.prepare()
        self.vf_h = RefresherLayout.headerHeight
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.vf_y = -self.vf_h - RefresherLayout.ignoredTop
    }
    
    override func contentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        if self.window == nil { return }
        guard let offset = change?[.newKey] as? CGPoint else { return }
        super.contentOffsetDidChange(change)
        if state == .refreshing {
            scrollView.contentInset.top = self.vf_h + originalInset.top
            return
        }
        let offsetY = offset.y
        let happenY = -originalInset.top
        if offsetY > happenY { return }
        let showY = happenY - self.vf_h
        let pullingPercent = (happenY - offsetY) / self.vf_h
        self.pullingPercent = pullingPercent > 1 ? 1 : pullingPercent
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if state == .idle && offsetY < showY {
                state = .willRefresh
            }
            else if state == .willRefresh && offsetY > showY {
                state = .idle
            }
        }
        
    }
    
    override var state: RefresherState! {
        didSet {
            if oldValue == state { return }
            if state == .idle {
                if oldValue != .refreshing { return }
                
            }
        }
    }
    
}

extension UIView {
    
    private  func currentVC(_ view: UIView) -> UIViewController? {
        if let responder = view.next as? UIViewController {
            return responder
        }
        else if let sup = view.superview {
            return currentVC(sup)
        }
        else {
            return nil
        }
    }
    
    var vc: UIViewController? {
        return currentVC(self)
    }
}

func currentVC() -> UIViewController? {
    guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
        return nil
    }
    
    func current(_ vc: UIViewController?) -> UIViewController? {
        guard let vc = vc else { return nil }
        if let presented = vc.presentedViewController {
            return current(presented)
        }
        if let tabbarVC = vc as? UITabBarController {
            return current(tabbarVC.selectedViewController)
        }
        if let navVC = vc as? UINavigationController {
            return current(navVC.topViewController)
        }
        return vc
    }
    return current(vc)
}
