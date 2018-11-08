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
        self.tabBarController?.title = NSLocalizedString("tablayout_notification", comment: "")
        
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = AppColor.colors.backgroundColor
//            self?.navigationController?.navigationBar.barTintColor = AppColor.colors.navigationBackgroundColor
        }
        
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
    
    var setBadge: ((_ count: Int) -> Void)?
    
    @objc func refreshData() {
        let token = UserDefaults.standard.string(forKey: "token")
        if token == nil {
            UIAlertController.showAlert(message: NSLocalizedString("settings_login_tip", comment: ""))
            self.data = [Message]()
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        } else {
            provider.request(.messages(token: token!)) { (res) in
                switch res {
                case .success(let response):
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let result = try! decoder.decode(Result<Notification>.self, from: response.data)
                    self.data = (result.data?.hasnot_read_messages)! + (result.data?.has_read_messages)!
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.reloadData()
                    if let hasnot_read_count = result.data?.hasnot_read_messages.count, hasnot_read_count > 0 {
                        self.navigationController?.view.makeToast("\(NSLocalizedString("note_update_unread_tip", comment: ""))\(hasnot_read_count)")
                    }
                    self.message_mark_all()
                case .failure(let error):
                    self.tableView.mj_header.endRefreshing()
                    UIAlertController.showAlert(message: error.errorDescription!)
                }
            }
        }
    }
    
    func message_mark_all() {
        if UserDefaults.standard.string(forKey: "token") != nil {
            provider.request(.message_mark_all(UserDefaults.standard.string(forKey: "token")!)) { (res) in
                switch res {
                case .success(_):
                    self.setBadge?(0)
                case .failure(_):
                    print(NSLocalizedString("note_mark_unread_tip", comment: ""))
//                    self.view.makeToast("标记未读通知已读失败")
                }
            }
        }
    }
    
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
        let topicDetailWebViewController = TopicDetailWebViewController()
        topicDetailWebViewController.topic_id = message.topic.id
        self.navigationController?.pushViewController(topicDetailWebViewController, animated: true)
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
