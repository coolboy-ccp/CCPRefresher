//
//  RefresherBase.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class RefresherBase: UIView {

    open func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    open func placeSubviews() {}
    
    override func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    
    
}
