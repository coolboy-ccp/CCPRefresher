//
//  ViewController.swift
//  CCPRefresher
//
//  Created by clobotics_ccp on 2019/8/20.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    private lazy var datasource: [String] = {
        return (0 ... 20).map { "index____\($0)" }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "RefresherDemoCell")
        tableview.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        header.backgroundColor = .red
        tableview.tableHeaderView = header
        let sub = UIView(frame: CGRect(x: -25, y: -25, width: 100, height: 30))
        sub.backgroundColor = .gray
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        footer.backgroundColor = .green
        tableview.tableFooterView = footer
        tableview.addSubview(sub)
        tableview.prefetchDataSource = self
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RefresherDemoCell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print("--------------------\(indexPaths)")
//        guard let last = indexPaths.last else {
//            return
//        }
//        if last.row != datasource.count - 1 { return }
//        datasource += ["index_21"]
//        tableView.reloadData()
    }
    
    
}

