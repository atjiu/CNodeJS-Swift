//
//  SettingsTableViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/11/7.
//  Copyright © 2018 H. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var data = [
        ("", []),
        ("", [("baseline_brightness_2_black_24pt",NSLocalizedString("settings_theme", comment: ""))]),
        ("", [
            ("baseline_code_black_24pt",NSLocalizedString("settings_open_source", comment: "")),
            ("baseline_bug_report_black_24pt",NSLocalizedString("settings_issues", comment: ""))
        ]),
        ("", [("baseline_warning_white_24pt",NSLocalizedString("settings_logout", comment: ""))])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("my_settings", comment: "")
        
        self.tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: "simpleCell")
        self.tableView.register(SwitchButtonTableViewCell.self, forCellReuseIdentifier: "switchCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logoutCell")
        self.tableView.separatorStyle = .none
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = AppColor.colors.backgroundColor
            self?.navigationController?.navigationBar.tintColor = AppColor.colors.navigationBackgroundColor
//            self?.navigationController?.navigationBar.barTintColor = AppColor.colors.navigationBackgroundColor
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0, 20, 20, 20][section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data[section].1.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchButtonTableViewCell
            cell.switchClick = {[weak self] in
                if AppColor.sharedInstance.style == AppColor.AppColorStyleDefault {
                    AppColor.sharedInstance.setStyleAndSave(AppColor.AppColorStyleDark)
                } else {
                    AppColor.sharedInstance.setStyleAndSave(AppColor.AppColorStyleDefault)
                }
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! SimpleTableViewCell
            cell.bind(icon: data[indexPath.section].1[indexPath.row].0, title: data[indexPath.section].1[indexPath.row].1)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            
            let selectedBackgroundView = UIView()
            cell.selectedBackgroundView = selectedBackgroundView
            
            cell.themeChangedHandler = {[weak self] (style) -> Void in
                cell.backgroundColor = AppColor.colors.cellBackgroundColor
                selectedBackgroundView.backgroundColor = AppColor.colors.backgroundColor
            }
            
            cell.textLabel?.text = data[indexPath.section].1[indexPath.row].1
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.textAlignment = .center
            if UserDefaults.standard.string(forKey: "token") == nil {
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuName = data[indexPath.section].1[indexPath.row].1
        if menuName == NSLocalizedString("settings_open_source", comment: "") {
            UIApplication.shared.open(URL(string: "https://github.com/tomoya92/CNodeJS-Swift")!, options: [:]) { (success) in
                //打开浏览器成功了，做点其它的东东
            }
        } else if menuName == NSLocalizedString("settings_issues", comment: "") {
            UIApplication.shared.open(URL(string: "https://github.com/tomoya92/CNodeJS-Swift/issues")!, options: [:]) { (success) in
                //打开浏览器成功了，做点其它的东东
            }
        }
        if UserDefaults.standard.string(forKey: "token") != nil {
            if menuName == NSLocalizedString("settings_logout", comment: "") {
                UIAlertController.showConfirm(message: NSLocalizedString("settings_logout_tip", comment: "")) { (_) in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    self.view.makeToast(NSLocalizedString("alert_success", comment: ""))
                }
            }
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
