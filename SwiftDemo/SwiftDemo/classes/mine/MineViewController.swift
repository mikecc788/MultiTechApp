//
//  MineViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/28.
//

import Foundation
import UIKit
class MineViewController:UIViewController{
    private let LBFMMineMakeCellID = "LBFMMineMakeCell"
    private let LBFMMineShopCellID = "LBFMMineShopCell"
    
    private lazy var dataSource: Array = {
        return [[["icon":"钱数", "title": "分享赚钱"],
                 ["icon":"沙漏", "title": "免流量服务"]],
                [["icon":"扫一扫", "title": "扫一扫"],
                 ["icon":"月亮", "title": "夜间模式"]],
                [["icon":"意见反馈", "title": "帮助与反馈"]]]
    }()
    // 懒加载顶部头视图
    private lazy var headerView:LBFMMineHeaderView = {
        let view = LBFMMineHeaderView.init(frame: CGRect(x:0, y:0, width:kScreenWidth, height: 300))
        view.delegate = self
        return view
    }()
    // 懒加载TableView
    private lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame:CGRect(x:0, y:0, width:kScreenWidth, height:kScreenHeight), style: UITableView.Style.plain)
        tableView.contentInset = UIEdgeInsets(top: -CGFloat(UIDevice.inn_NavBarH()), left: 0, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = LBFMDownColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LBFMMineMakeCell.self, forCellReuseIdentifier: LBFMMineMakeCellID)
        tableView.tableHeaderView = headerView
        return tableView
    }()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.headerView.stopAnimationViewAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.setAnimationViewAnimation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
}
extension MineViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 100
        }else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:LBFMMineMakeCell = tableView.dequeueReusableCell(withIdentifier: LBFMMineMakeCellID, for: indexPath) as! LBFMMineMakeCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let sectionArray = dataSource[indexPath.section-1]
            let dict: [String: String] = sectionArray[indexPath.row]
            cell.imageView?.image =  UIImage(named: dict["icon"] ?? "")
            cell.textLabel?.text = dict["title"]
            if indexPath.section == 3 && indexPath.row == 1{
                let cellSwitch = UISwitch.init()
                cell.accessoryView = cellSwitch
            }else {
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = LBFMDownColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = LBFMDownColor
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
}
extension MineViewController:MineMakeCellClickDelegate{
    func clcikItem(index: Int) {
        print(index)
    }
}
/// 首页视图左消息，右设置 按钮点击代理方法
extension MineViewController : LBFMMineHeaderViewDelegate {
    func shopBtnClick(tag:Int) {
        
    }
}
