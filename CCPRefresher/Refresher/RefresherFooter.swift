//
//  RefresherFooter.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class RefresherFooter: RefresherBase {
    override func prepare() {
        super.prepare()
        self.vf_h = RefresherLayout.footerHeight
    }
    
    func noMore() {
        state = .noMoreData
    }
    

}
