//
//  LabelLoader.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/9/6.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class LabelLoader: UIView, RefresherCustomer {
    var height: CGFloat {
        return 40
    }
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = bottomLabelConfig.stateFont
        label.textColor = bottomLabelConfig.stateColor
        label.text = bottomLabelConfig.stateStrings[.normal]
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let inditor = UIActivityIndicatorView()
        inditor.tintColor = bottomLabelConfig.inditorColor
        inditor.hidesWhenStopped = true
        return inditor
    }()
    
    private lazy var imageV: UIImageView = {
        let imgV = UIImageView()
        if let img = UIImage(named: bottomLabelConfig.imageNmae) {
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
    
    var type: Position {
        return .bottom
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil { return }
        addSubview(stateLabel)
        addSubview(imageV)
        addSubview(indicator)
    }
    
    func placeSubviews() {
        stateLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        
        imageV.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.right.equalTo(stateLabel.snp.left).offset(-10)
        }
        
        indicator.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.right.equalTo(stateLabel.snp.left).offset(-10)
        }
    }
    
    var hight: CGFloat {
        return bottomLabelConfig.height
    }
    
    func change(_ state: RefresherState) {
        stateLabel.text = bottomLabelConfig.stateStrings[state]
        switch state  {
        case .normal:
            normal()
        case .willDo:
            willDo()
        case .doing:
            doing()
        case .nomore: break
            
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
    
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = bottomLabelConfig.backgroundColor
    }

}
