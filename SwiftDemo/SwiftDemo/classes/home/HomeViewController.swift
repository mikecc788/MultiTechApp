//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/24.
//

import Foundation
import UIKit
import Flutter
// 创建一个管理自定义类型数据的实例


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nameArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameArr = ["Core Animation", "Kingfisher+R.swift", "JSON+Dollar", "Alamofire", "泛型+协议+闭包", "横向滑动", "ble", "Flutter Page1"]
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "INNHomeViewCell", bundle: nil), forCellReuseIdentifier: "INNHomeViewCell")
        
        let url = URL(string: "http://110.41.41.11:8080/test")!
        let versionManager = GenericNetworkManager<Version>(url: url)
        versionManager.fetch { result in
            switch result {
                case .success(let user):
                print("User: \(user.message), Email: \(user.timestamp) :\(user.version)")
                case .failure(let error):
                    print("Error: \(error)")
                }
        }
        
        let rawUrl = URL(string: "http://110.41.41.11:8080/test")!
        let rawDataManager = RawDataManager(url: rawUrl)

        rawDataManager.fetch { result in
            switch result {
            case .success(let data):
                print("Raw data size: \(data.count) bytes \(result)")
                if let string = String(data: data, encoding: .utf8) {
                           print("Received string: \(string)")
                       } else {
                           print("Failed to decode data as a string.")
                       }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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
            pushViewController(BLEVC())
        case 0:
            pushViewController(AnimationVC())
        case 7:
            openFlutterPage()
        default:
            break
        }
    }
    
    func pushViewController(_ viewController:UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
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
