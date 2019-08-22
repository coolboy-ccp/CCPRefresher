//
//  RefresherBase.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit
import CCPFrame

enum RefresherState {
    case idle
    case willRefresh
    case refreshing
    case noMoreData
}


public protocol RefresherDelegate: NSObjectProtocol {
    func refreshing(_ refresher: RefresherBase)
}


open class RefresherBase: UIView {
    
    public typealias RefreshingClosure = (RefresherBase) -> ()
    public typealias RefreshingProgress = (CGFloat) -> ()
    
    private(set) var scrollView: UIScrollView!
    private(set) var originalInset: UIEdgeInsets!
    private(set) var callback: RefreshingClosure?
    private(set) var progress: RefreshingProgress?
    
    
    private(set) weak var delegate: RefresherDelegate?
    
    var pullingPercent: CGFloat = 0 {
        didSet {
            if oldValue == pullingPercent { return }
            progress?(pullingPercent)
        }
    }
    
    var state: RefresherState! {
        didSet {
            if oldValue == state { return }
            self.setNeedsLayout()
        }
    }
    
    
    public convenience init(scrollView: UIScrollView, frame: CGRect, callback: RefreshingClosure? = nil, progress: RefreshingProgress? = nil){
        self.init(scrollView: scrollView, frame: frame)
        self.callback = callback
    }
    
    public convenience init(scrollView: UIScrollView, frame: CGRect, delegate: RefresherDelegate? = nil, progress: RefreshingProgress? = nil) {
        self.init(scrollView: scrollView, frame: frame)
        self.delegate = delegate
    }
    
    private convenience init(scrollView: UIScrollView, frame: CGRect) {
        self.init(frame: frame)
        self.scrollView = scrollView
        self.prepare()
        self.state = .idle
    }

    open func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
        self.vf_w = scrollView.vf_w
        self.vf_x = scrollView.contentInset.left
        scrollView.alwaysBounceVertical = true
        originalInset = scrollView.contentInset
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    open func placeSubviews() {}
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
    private func addObservers() {
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
        scrollView.panGestureRecognizer.addObserver(self, forKeyPath: "state", options: [.new], context: nil)
    }
    
    private func removeObservers() {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentSize")
        scrollView.panGestureRecognizer.removeObserver(self, forKeyPath: "state")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        assert(scrollView.isUserInteractionEnabled, RefresherError.superViewDisable(scrollView).localizedDescription)
        
    }
    
    open func panStateDidChange(_ change: [NSKeyValueChangeKey : Any]?){}
    open func contentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?){}
    open func contentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?){}
    
    func executeCallback() {
        delegate?.refreshing(self)
        callback?(self)
    }
    
    func start() {
        UIView.animate(withDuration: AnimationDuration.slow) {
            self.alpha = 1.0;
        }
        pullingPercent = 1.0
        if self.window != nil {
            state = .refreshing
        }
    }
    
    func stop() {
        state = .idle
    }
    
}
