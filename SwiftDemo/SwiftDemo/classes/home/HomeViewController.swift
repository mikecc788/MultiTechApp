//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/24.
//

import Foundation
import UIKit
import Flutter

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nameArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameArr = ["多线程", "Kingfisher+R.swift", "JSON+Dollar", "Alamofire", "泛型+协议+闭包", "横向滑动", "ble", "Flutter Page1"]
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "INNHomeViewCell", bundle: nil), forCellReuseIdentifier: "INNHomeViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "INNHomeViewCell", for: indexPath) as!INNHomeViewCell
        cell.name.text = nameArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            navigationController?.pushViewController(JSONViewController(), animated: true)
        case 3:
            navigationController?.pushViewController(AlamofireViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(KingfisherViewController(), animated: true)
        case 4, 5:
            navigationController?.pushViewController(GenericViewController(), animated: true)
        case 6:
            navigationController?.pushViewController(BLEVC(), animated: true)
        case 7:
            openFlutterPage()
        default:
            break
        }
    }
    
    private func openFlutterPage() {
        let flutterViewController = FlutterEngineManager.shared.getFlutterViewController()
        flutterViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(flutterViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FlutterEngineManager.shared.detachCurrentFlutterViewController()
    }
}
