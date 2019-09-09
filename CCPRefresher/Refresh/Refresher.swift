//
//  Refresher.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/5.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit
import CCPFrame

public protocol RefresherCustomer where Self: UIView {
    var type: Position { get }
    var height: CGFloat { get }
    
    func placeSubviews()
    func change(_ state: RefresherState)
    func pull(_ percent: CGFloat)
}

extension RefresherCustomer {
    func change(_ state: RefresherState){}
    func pull(_ percent: CGFloat){}
    func placeSubviews() {}
}

open class Refresher: UIView {
        
    private var scrollView: UIScrollView!
    private var originalInset: UIEdgeInsets = .zero
    private var custom: RefresherCustomer!
    private var pos: Position!
    private var refreshingHandler: VoidClosure?
    
    
    private var pullPercent: CGFloat = 0 {
        didSet {
            custom.pull(pullPercent)
        }
    }
    
    private var state: RefresherState = .normal {
        didSet {
            if oldValue == state { return }
            switch state {
            case .normal:
                if oldValue != .doing { break }
                UIView.animate(withDuration: 0.3) {
                    self.scrollView.contentInset = self.originalInset
                }
                pullPercent = 0
            case .doing:
                pos == .top ? setupRefreshing() : setupLoading()
                refreshingHandler?()
            default: break
            }
            custom.change(state)
        }
    }
    
    convenience init(_ scrollView: UIScrollView, _ custom: RefresherCustomer, _ refreshingHandler: VoidClosure?) {
        self.init(frame: .zero)
        self.refreshingHandler = refreshingHandler
        self.scrollView = scrollView
        self.originalInset = scrollView.contentInset
        self.autoresizingMask = .flexibleWidth
        self.custom = custom
        self.pos = custom.type
        self.backgroundColor = .clear
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil { return }
        addSubview(custom)
        addObservers()
    }
    
    private func setupFrame() {
        self.frame = CGRect(x: originalInset.left, y: 0, width: scrollView.vf_w, height: custom.height)
        pos == .top ? setupTopY() : setupBottomY()
        custom.frame = self.bounds
    }
    
    private func setupTopY() {
        self.vf_y = -(originalInset.top + custom.height)
    }
    
    private func setupBottomY() {
        let contentH = scrollView.contentSize.height + originalInset.bottom
        let scrollViewH = scrollView.vf_h
        self.vf_y = max(contentH, scrollViewH)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupFrame()
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
    
    deinit {
        removeObservers()
    }
    
    private func contentOffset(_ change: [NSKeyValueChangeKey : Any]) {
        guard let offset = change[.newKey] as? CGPoint else { return }
        setupState(offset)
    }
    
    private func contentSize(_ change: [NSKeyValueChangeKey : Any]) {
        if pos == .bottom { setupBottomY() }
    }
    
    private func setupState(_ offset: CGPoint) {
        pos == .top ? topState(offset) : bottomState(offset)
    }
    
    private func setupRefreshing() {
        var inset = originalInset
        inset.top += custom.height
        scrollView.contentInset = inset
        var offset = scrollView.contentOffset
        offset.y = -inset.top
        scrollView.setContentOffset(offset, animated: false)
        UserDefaults.standard.setValue(Date(), forKey: lastUpdateTimeKey)
        UserDefaults.standard.synchronize()
    }
    
    private func setupLoading() {
        var inset = originalInset
        inset.bottom = scrollView.contentSize.height - scrollView.vf_h + originalInset.bottom + custom.vf_h
        scrollView.contentInset = inset
        var offset = scrollView.contentOffset
        offset.y = inset.bottom
        scrollView.setContentOffset(offset, animated: false)
    }
    
    private func topState(_ offset: CGPoint) {
        let happenY = -originalInset.top
        if offset.y > happenY { return }
        let willRefreshY = happenY - self.vf_h
        let pullPercent = (happenY - offset.y) / self.vf_h
        self.pullPercent = pullPercent > 1.0 ? 1.0 : pullPercent
        if scrollView.isDragging {
            
            if state == .normal && offset.y < willRefreshY {
                state = .willDo
            }
            else if state == .willDo && offset.y >= willRefreshY {
                state = .normal
            }
            else if state == .doing {
                setupRefreshing()
            }
        }
        else if state == .willDo {
            state = .doing
        }
    }
    
    func begin(handler: VoidClosure? = nil) {
        if handler != nil {
            refreshingHandler = handler
        }
        state = .doing
    }
    
    func finish(style: FinishStyle = .normal) {
        if pos == .top {
            state = .normal
            return
        }
        state = style == .normal ? .normal : .nomore
    }
    
    private func bottomState(_ offset: CGPoint) {
        if state == .doing || state == .nomore { return }
        let happenY = scrollView.contentSize.height - scrollView.vf_h + originalInset.bottom
        if offset.y <= happenY { return }
        let percent = (offset.y - happenY) / self.vf_h
        pullPercent = percent > 1.0 ? 1.0 : percent
        if scrollView.isDragging {
            let willRefreshY = happenY + custom.height
            if state == .normal && offset.y > willRefreshY {
                print(happenY, offset.y)
                state = .willDo
            }
            else if state == .willDo && offset.y <= willRefreshY {
                state = .normal
            }
            return
        }
        if state == .willDo {
            state = .doing
        }
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
