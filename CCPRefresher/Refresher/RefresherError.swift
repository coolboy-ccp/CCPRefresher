//
//  RefresherError.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

enum RefresherError: Error {
    case invalidSuperView(UIView)
    case superViewDisable(UIView)
    case noCallback(UIView)
}

extension RefresherError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidSuperView(let sup):
            return "[RefresherError] \(String(describing: sup)) Invalid Supview".localized
        case .superViewDisable(let sup):
            return  "[RefresherError]  \(type(of: sup)))" + "Supview is disable".localized
        case .noCallback(let sup):
            return "[RefresherError] \(type(of: sup))" + "No callback".localized
        default:
            ()
        }
    }
}
