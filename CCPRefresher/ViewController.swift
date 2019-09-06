//
//  ViewController.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        scrollview.refresh(.top)
    }
    
}

