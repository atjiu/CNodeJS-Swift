//
//  OpenSourceTableViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/11/16.
//  Copyright © 2018 H. All rights reserved.
//

import UIKit

class OpenSourceTableViewController: UITableViewController {
    
    var data = [
        ("SnapKit", "https://github.com/SnapKit/SnapKit"),
        ("Kingfisher", "https://github.com/onevcat/Kingfisher"),
        ("Moya", "https://github.com/Moya/Moya"),
        ("MJRefresh", "https://github.com/CoderMJLee/MJRefresh"),
        ("XLPagerTabStrip", "https://github.com/xmartlabs/XLPagerTabStrip"),
        ("UIColor_Hex_Swift", "https://github.com/yeahdongcn/UIColor-Hex-Swift"),
        ("DeviceKit", "https://github.com/dennisweissmann/DeviceKit"),
        ("SwiftyJSON", "https://github.com/SwiftyJSON/SwiftyJSON"),
        ("YBImageBrowser", "https://github.com/indulgeIn/YBImageBrowser"),
        ("FDFullscreenPopGesture", "https://github.com/forkingdog/FDFullscreenPopGesture"),
        ("KVOController", "https://github.com/facebook/KVOController"),
        ("Toast-Swift", "https://github.com/scalessec/Toast-Swift"),
        ("swiftScan", "https://github.com/MxABC/swiftScan"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("settings_open_source", comment: "")

        self.tableView.separatorStyle = .none
        self.tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = AppColor.colors.backgroundColor
            self?.navigationController?.navigationBar.tintColor = AppColor.colors.navigationBackgroundColor
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleTableViewCell
        cell.selectionStyle = .none
        cell.bind(icon: nil, title: data[indexPath.row].0, rightLabelText: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: data[indexPath.row].1)!, options: [:]) { (success) in
            //打开浏览器成功了，做点其它的东东
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
