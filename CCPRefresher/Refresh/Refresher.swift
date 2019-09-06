//
//  Refresher.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/5.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit
import CCPFrame

public enum RefresherType: Int {
    case top
    case bottom
}

public extension RefresherType {
    func refresher(_ scrollView: UIScrollView, _ height: CGFloat) -> Refresher {
        switch self {
        case .top:
            return Refresher(scrollView, HeaderDemo(35))
        default:
            return Refresher(scrollView, HeaderDemo(35))
        }
    }
}

extension UIScrollView {
    
    func refresh(_ type: RefresherType) {
        self.addSubview(type.refresher(self, 35))
    }
}

public enum RefresherState {
    case normal
    case pulling
    case refreshing
    case nomore
}

public protocol RefresherCustom where Self: UIView {
    var type: RefresherType { get }
    func contentOffset(_ offset: CGPoint)
    func contentSize(_ size: CGSize)
    func placeSubviews()
    func change(state: RefresherState)
}


open class Refresher: UIView {
    
    private var scrollView: UIScrollView!
    private var originalInset: UIEdgeInsets!
    private var custom: RefresherCustom!
    
    convenience init(_ scrollView: UIScrollView, _ custom: RefresherCustom) {
        self.init(frame: .zero)
        self.scrollView = scrollView
        self.originalInset = scrollView.contentInset
        self.autoresizingMask = .flexibleWidth
        self.custom = custom
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil { return }
        self.frame = CGRect(x: originalInset.left, y: -(originalInset.top + custom.vf_h), width: scrollView.vf_w, height: custom.vf_h)
        custom.frame = self.bounds
        addSubview(custom)
        addObservers()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        custom.placeSubviews()
    }
    
    private func addObservers() {
        scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }
    
    private func removeObservers() {
        scrollView.removeObserver(self, forKeyPath: "contentSize")
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    private func contentOffset(_ change: [NSKeyValueChangeKey : Any]) {
        guard let offset = change[.newKey] as? CGPoint else { return }
        custom.contentOffset(offset)
    }
    
    private func contentSize(_ change: [NSKeyValueChangeKey : Any]) {
        guard let size = change[.newKey] as? CGSize else { return }
        custom.contentSize(size)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let kp = keyPath else { return }
        guard let change = change else { return }
        switch kp {
        case "contentSize":
            contentSize(change)
        case "contentOffset":
            contentOffset(change)
        default:()
            
        }
    }
}
