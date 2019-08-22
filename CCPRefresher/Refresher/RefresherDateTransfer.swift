//
//  RefresherDate.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/22.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

protocol RefresherDateTransfer {
    func dateString(with date: Date?) -> String?
}

class RefresherDateTransferDefault: RefresherDateTransfer {
    func dateString(with date: Date?) -> String? {
        guard let date = date else {  return nil }
        let calendar = Calendar.current
        let components =
        calendar.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: <#T##Date#>)
        
    }
    
    
}

