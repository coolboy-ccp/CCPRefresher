//
//  RefresherTime.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/9.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit
import CCPDate


final class RefresherTime {
    
    static func toString(_ handler: ((Date?) -> String)? = nil) -> String? {
        if let handler = handler {
            return handler(time)
        }
        return string
    }
    
    private static var time: Date? {
        guard let last = UserDefaults.standard.object(forKey: lastUpdateTimeKey) as? Date else {
            return nil
        }
        return last
    }
    
    private static var string: String {
        var str = "没有记录"
        if let time = time {
            switch time ~- Date() {
            case .ago(let period):
                switch period {
                case .day(let day):
                    if day == 1 {
                        str = "昨天 \(time.string(formatter: .HMS))"
                    }
                    str = time.string(formatter: .MDHMS)
                case .year(_):
                    str = time.string(formatter: .YMDHMS)
                case .month(_), .week(_):
                    str = time.string(formatter: .MDHMS)
                default:
                    str = "今天 \(time.string(formatter: .HMS))"
                }
            case .future(_):
                break
            case .same:
                str = "刚刚"
            }
        }
        return "上一次刷新时间: \(str)"
    }
}
