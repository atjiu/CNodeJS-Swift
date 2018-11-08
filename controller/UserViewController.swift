//
//  UserViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
    
    lazy var headerView: UserHeaderTableViewCell = {
        var cell = UserHeaderTableViewCell()
        cell.type = 0
        cell.scanQrCodeViewController = { [weak self] vc in
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        cell.startReloadDataRefreshing = { [weak self] in
            self?.view.makeToastActivity(.center)
        }
        cell.endReloadDataRefreshing = { [weak self] in
            self?.view.hideToastActivity()
        }
        cell.updateMenuStatus = { [weak self] in
            self?.tableView.reloadData()
        }
        cell.toastMessage = {[weak self] msg in
            self?.navigationController?.view.makeToast(msg)
        }
        return cell
    }()
    
    var data = [
        ("", []),
        ("", [
            ("baseline_account_circle_black_24pt",NSLocalizedString("my_user_center", comment: "")),
//            ("baseline_view_list_black_24pt",NSLocalizedString("my_topics", comment: "")),
//            ("baseline_reply_all_black_24pt",NSLocalizedString("my_replies", comment: "")),
            ("baseline_collections_bookmark_black_24pt",NSLocalizedString("my_collects", comment: "")),
        ]),
//        ("", [
//            ("baseline_code_black_24pt",NSLocalizedString("settings_open_source", comment: "")),
//            ("baseline_bug_report_black_24pt",NSLocalizedString("settings_issues", comment: ""))
//        ]),
//        ("", [("baseline_warning_white_24pt",NSLocalizedString("settings_logout", comment: ""))])
        ("", [("baseline_settings_black_24pt",NSLocalizedString("my_settings", comment: ""))])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = NSLocalizedString("tablayout_my", comment: "")
        
        self.tableView.addSubview(headerView)
    
        self.tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: "userCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settings_cell")
        self.tableView.separatorStyle = .none
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = footerView
        
        // 加载当前用户信息
        self.headerView.bind();
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = AppColor.colors.backgroundColor
//            self.navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: UIColor(CNodeColor.navigationBackgroundColor), night: UIColor(CNodeColor.navigationBackgroundColor_dark))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [200, 0, 20][section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! SimpleTableViewCell
            cell.bind(icon: data[indexPath.section].1[indexPath.row].0, title: data[indexPath.section].1[indexPath.row].1)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell", for: indexPath)
            let selectedBackgroundView = UIView()
            cell.selectedBackgroundView = selectedBackgroundView
            cell.imageView?.image = UIImage(named: data[indexPath.section].1[indexPath.row].0)?.withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = AppColor.colors.titleColor
            cell.textLabel?.textColor = AppColor.colors.titleColor
            cell.textLabel?.text = data[indexPath.section].1[indexPath.row].1
            cell.themeChangedHandler = {[weak self] (style) -> Void in
                cell.backgroundColor = AppColor.colors.cellBackgroundColor
                selectedBackgroundView.backgroundColor = AppColor.colors.backgroundColor
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuName = data[indexPath.section].1[indexPath.row].1
        if menuName == NSLocalizedString("my_settings", comment: "") {
            let settingsTableViewController = SettingsTableViewController()
            self.navigationController?.pushViewController(settingsTableViewController, animated: true)
            return;
        }
        if UserDefaults.standard.string(forKey: "token") != nil {
            if menuName == NSLocalizedString("my_user_center", comment: "") {
                let userCenterViewController = UserCenterViewController()
                userCenterViewController.type = 0
                userCenterViewController.loginname = UserDefaults.standard.string(forKey: "loginname")
                self.navigationController?.pushViewController(userCenterViewController, animated: true)
            } else if menuName == NSLocalizedString("my_collects", comment: "") {
                let collectTableViewController = CollectTableViewController()
                self.navigationController?.pushViewController(collectTableViewController, animated: true)
            }
        } else {
            UIAlertController.showAlert(message: NSLocalizedString("settings_login_tip", comment: ""))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "token") == nil {
            self.headerView.unbind()
        }
        self.tableView.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
