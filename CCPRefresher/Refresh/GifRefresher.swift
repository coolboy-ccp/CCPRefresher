//
//  GifRefresher.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/6.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class GifRefresher: UIView, RefresherCustomer {
    var type: Position {
        return .top
    }
    
    func placeSubviews() {
        
    }
    
    var height: CGFloat {
        return 80
    }

}
