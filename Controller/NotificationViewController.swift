//
//  LeftMenuViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import Moya

class NotificationViewController: UITableViewController {
    
    var provider = MoyaProvider<CNodeService>()
    
    var data = [Message]()
    fileprivate var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "通知"
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.mj_header = RefreshView(refreshingBlock: {
            [weak self] () -> Void in
            self?.refreshData()
        })
        
        // 添加加载更多组件
//        self.tableView.mj_footer = LoadMoreView(refreshingBlock: {
//            [weak self] () -> Void in
//            self?.loadMoreData()
//        })
        
        //加载数据
        self.tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refreshData() {
        let token = UserDefaults.standard.string(forKey: "token")
        if token == nil {
            UIAlertController.showAlert(message: "请先登录!")
            self.data = [Message]()
            self.tableView.mj_header.endRefreshing()
        } else {
            provider.request(.messages(token: token!)) { (res) in
                switch res {
                case .success(let response):
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let result = try! decoder.decode(Result<Notification>.self, from: response.data)
                    self.data = (result.data?.has_read_messages)! + (result.data?.hasnot_read_messages)!
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.reloadData()
                case .failure(let error):
                    self.tableView.mj_header.endRefreshing()
                    UIAlertController.showAlert(message: error.errorDescription!)
                }
            }
        }
    }
    
//    @objc func loadMoreData() {
//        provider.request(.collect(loginname: UserDefaults.standard.string(forKey: "loginname")!, page: self.page)) { (res) in
//            switch res {
//            case .success(let response):
//                self.page += 1
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
//                let result = try! decoder.decode(Result<Notification>.self, from: response.data)
//                self.data += result.data!.has
//                self.tableView.mj_footer.endRefreshing()
//                if result.data!.count < 50 {
//                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                }
//                self.tableView.reloadData()
//            case .failure(let error):
//                self.tableView.mj_footer.endRefreshing()
//                self.view.makeToast(error.errorDescription)
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell
        cell.bind(data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = data[indexPath.row]
        let topicDetailViewController = TopicDetailTableViewController()
        //        let topicDetailViewController = TopicDetailViewController()
        topicDetailViewController.topic = message.topic
        self.navigationController?.pushViewController(topicDetailViewController, animated: true)
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
