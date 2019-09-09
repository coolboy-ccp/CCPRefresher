//
//  RefresherConfig.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/6.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

public protocol RefresherLabelConfig {
    var stateFont: UIFont { get }
    var stateColor: UIColor { get }
    var timeFont: UIFont { get }
    var timeColor: UIColor { get }
    var stateStrings: [RefresherState : String] { get }
    var inditorColor: UIColor { get }
    var imageNmae: String { get }
    var backgroundColor: UIColor { get }
    var height: CGFloat { get }
    var topMargin: CGFloat { get }
    var bottomMargin: CGFloat { get }
    var timeHandler: ((Date?) -> String)? { get }
}

extension RefresherLabelConfig {
    var backgroundColor: UIColor {
        return .gray
    }
    
    var stateFont: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    var stateColor: UIColor {
        return UIColor.rgba(60, 60, 60, 1.0)
    }
    
    var timeFont: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    var timeColor: UIColor {
        return UIColor.rgba(60, 60, 60, 1.0)
    }
    
    var inditorColor: UIColor {
        return UIColor.rgba(60, 60, 60, 1.0)
    }
    
    var imageNmae: String {
        return "arrow"
    }
    
    var topMargin: CGFloat {
        return 10
    }
    
    var bottomMargin: CGFloat {
        return 10
    }
    
     var timeHandler: ((Date?) -> String)? {
        return nil
    }
}

struct TopConfig: RefresherLabelConfig {
    var stateStrings: [RefresherState : String] {
        return [
            .normal : "下拉刷新",
            .willDo : "松开刷新",
            .doing : "正在刷新..."
        ]
    }
    
    var height: CGFloat {
        return 60
    }
}

struct BottomConfig: RefresherLabelConfig {
    var stateStrings: [RefresherState : String] {
        return [
            .normal : "上拉加载更多",
            .willDo : "松开加载",
            .doing : "正在加载...",
            .nomore : "没有更多数据"
        ]
    }
    
    var imageNmae: String {
        return "arrow_up"
    }
    
    var height: CGFloat {
        return 40
    }
}

public var topLabelConfig: RefresherLabelConfig = TopConfig()
public var bottomLabelConfig: RefresherLabelConfig = BottomConfig()
