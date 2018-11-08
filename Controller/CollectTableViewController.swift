//
//  CollectTableViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/14.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import Moya
import MJRefresh

class CollectTableViewController: UITableViewController {
    
    var provider = MoyaProvider<CNodeService>()
    
    var data = [Topic]()
    fileprivate var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("my_collects", comment: "")
        
        self.tableView.register(UserTopicsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        
        self.tableView.mj_header = RefreshView(refreshingBlock: {
            [weak self] () -> Void in
            self?.refreshData()
        })
        
        // 添加加载更多组件
        self.tableView.mj_footer = LoadMoreView(refreshingBlock: {
            [weak self] () -> Void in
            self?.loadMoreData()
        })
        
        //加载数据
        self.tableView.mj_header.beginRefreshing()
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = AppColor.colors.backgroundColor
            self?.navigationController?.navigationBar.tintColor = AppColor.colors.navigationBackgroundColor
//            self?.navigationController?.navigationBar.barTintColor = AppColor.colors.navigationBackgroundColor
        }
    }
    
    
    @objc func refreshData() {
        self.page = 1
        provider.request(.collect(loginname: UserDefaults.standard.string(forKey: "loginname")!, page: self.page)) { (res) in
            switch res {
            case .success(let response):
                self.page += 1
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try! decoder.decode(Result<[Topic]>.self, from: response.data)
                self.data = result.data!
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
            case .failure(let error):
                self.tableView.mj_header.endRefreshing()
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }
    
    @objc func loadMoreData() {
        provider.request(.collect(loginname: UserDefaults.standard.string(forKey: "loginname")!, page: self.page)) { (res) in
            switch res {
            case .success(let response):
                self.page += 1
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try! decoder.decode(Result<[Topic]>.self, from: response.data)
                self.data += result.data!
                self.tableView.mj_footer.endRefreshing()
                if result.data!.count < 50 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.tableView.mj_footer.endRefreshing()
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTopicsTableViewCell
        cell.bind(data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = data[indexPath.row]
        let topicDetailWebViewController = TopicDetailWebViewController()
        topicDetailWebViewController.topic_id = topic.id
        self.navigationController?.pushViewController(topicDetailWebViewController, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
