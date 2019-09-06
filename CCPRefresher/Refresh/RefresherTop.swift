//
//  RefresherTop.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/5.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class RefresherTop: UIView, RefresherCustom {
    func contentSize(_ size: CGSize) {
        <#code#>
    }
    
    func placeSubviews() {
        <#code#>
    }
    
    func change(state: RefresherState) {
        <#code#>
    }
    
    var type: RefresherType {
        return .top
    }
    
    func contentOffset(_ offset: CGPoint) {
        
    }
}

//class HeaderDemo: UIView, RefresherCustom {
//    var type: RefresherType {
//        return .top
//    }
//    
//    convenience init(_ height: CGFloat) {
//        self.init(frame: CGRect(x:0, y: 0, width: 0, height: height))
//        self.backgroundColor = .purple
//    }
//    
//    private lazy var label: UILabel = {
//        let label = UILabel(frame: self.bounds)
//        label.text = "HeaderDemo"
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        return label
//    }()
//    
//    override func willMove(toSuperview newSuperview: UIView?) {
//        if newSuperview == nil { return }
//        self.addSubview(label)
//    }
//    
//    func contentOffset(_ offset: CGPoint) {
//        label.text = "\(offset.y)"
//    }
//    
//}
