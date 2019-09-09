//
//  RefresherTopLabel.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/6.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit
import CCPColor
import SnapKit

class LabelRefresher: UIView, RefresherCustomer {
    var height: CGFloat {
        return topLabelConfig.height
    }
    
    var type: Position {
        return .top
    }
    
    private lazy var indicator: UIActivityIndicatorView = {
        let inditor = UIActivityIndicatorView()
        inditor.tintColor = topLabelConfig.inditorColor
        inditor.hidesWhenStopped = true
        return inditor
    }()
    
    private lazy var imageV: UIImageView = {
         let imgV = UIImageView()
        if let img = UIImage(named: topLabelConfig.imageNmae) {
            if img.size.width > 30 {
                imgV.vf_w = 30
                imgV.vf_h = img.size.height / (img.size.width / 30)
            }
            else if img.size.width > 30 {
                imgV.vf_h = 30
                imgV.vf_w = img.size.width / (img.size.height / 30)
            }
            else {
                imgV.vf_size = img.size
            }
            imgV.contentMode = .scaleToFill
            imgV.image = img
            return imgV
        }
        imgV.vf_size = CGSize(width: 30, height: 30)
        return imgV
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = topLabelConfig.stateFont
        label.textColor = topLabelConfig.stateColor
        label.text = topLabelConfig.stateStrings[.normal]
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = topLabelConfig.timeFont
        label.textColor = topLabelConfig.timeColor
        label.text = RefresherTime.toString(topLabelConfig.timeHandler)
        return label
    }()
    
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = topLabelConfig.backgroundColor
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil { return }
        addSubview(timeLabel)
        addSubview(stateLabel)
        addSubview(imageV)
        addSubview(indicator)
    }
    
    func placeSubviews() {
        var labelLeft: ConstraintRelatableTarget = timeLabel.snp.left
        if stateLabel.text!.count > timeLabel.text!.count {
            labelLeft = stateLabel.snp.left
        }
        
        stateLabel.snp.makeConstraints {
            $0.top.equalTo(topLabelConfig.topMargin)
            $0.height.equalTo(timeLabel.snp.height)
            $0.bottom.equalTo(timeLabel.snp.top)
            $0.centerX.equalTo(self)
        }
        
        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(-topLabelConfig.bottomMargin)
            $0.centerX.equalTo(self)
        }
        
        imageV.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.right.equalTo(labelLeft).offset(-10)
        }
        
        indicator.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.right.equalTo(labelLeft).offset(-10)
        }
    }
    
    func change(_ state: RefresherState) {
        stateLabel.text = topLabelConfig.stateStrings[state]
        switch state {
        case .normal:
            normal()
        case .willDo:
            willDo()
        case .doing:
            doing()
        default: ()
        }
    }
    
    private func doing() {
        imageV.isHidden = true
        indicator.startAnimating()
    }
    
    private func showArrow() {
        imageV.isHidden = false
        indicator.stopAnimating()
    }
    
    private func normal() {
        showArrow()
        timeLabel.text = RefresherTime.toString(topLabelConfig.timeHandler)
        UIView.animate(withDuration: 0.3) {
            self.imageV.transform = .identity
        }
    }
    
    private func willDo() {
        showArrow()
        UIView.animate(withDuration: 0.3) {
            self.imageV.transform = CGAffineTransform(rotationAngle: -.pi)
        }
    }
}
