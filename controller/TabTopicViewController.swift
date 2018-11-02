//
//  TabTopicViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Moya
import SwiftyJSON

class TabTopicViewController: UITableViewController, IndicatorInfoProvider {
    
    var tabText: String!
    var tab: String!
    
    var provider = MoyaProvider<CNodeService>()
    fileprivate var page = 1
    var data = [Topic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //监听程序即将进入前台运行、进入后台休眠 事件
        NotificationCenter.default.addObserver(self, selector: #selector(TabTopicViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TabTopicViewController.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        self.tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 添加下拉刷新组件
//        self.view.addSubview(refresh)
//        self.refresh.addTarget(self, action: #selector(TabTopicViewController.refreshData), for: .valueChanged)
//        self.tableView.refreshControl? = refresh
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
        
        self.message_count()
    }
    
    @objc func refreshData() {
        self.page = 1
        provider.request(.topics(page: self.page, tab: self.tab)) { (res) in
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
        provider.request(.topics(page: self.page, tab: self.tab)) { (res) in
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopicTableViewCell
        cell.tabTopicViewController = self
        cell.bind(topic: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = data[indexPath.row]
        let topicDetailWebViewController = TopicDetailWebViewController()
        topicDetailWebViewController.topic_id = topic.id
        self.navigationController?.pushViewController(topicDetailWebViewController, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.tabText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func message_count() {
        if UserDefaults.standard.string(forKey: "token") != nil {
            provider.request(.message_count(UserDefaults.standard.string(forKey: "token")!)) { (res) in
                switch res {
                case .success(let response):
                    let json = try! JSON(data: response.data)
                    if json["success"] == true {
                        self.setBadge?(Int(json["data"].rawString()!)!)
                    } else {
                        // 清除用户的信息
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        UserDefaults.standard.synchronize()
                    }
                case .failure(_):
                    print("获取未读通知失败")
//                    self.navigationController?.view.makeToast("获取未读通知失败")
                }
            }
        }
    }
    
    var setBadge: ((_ count: Int) -> Void)?
    
    static var lastLeaveTime = Date()
    @objc func applicationWillEnterForeground(){
        //计算上次离开的时间与当前时间差
        //如果超过2分钟，则自动刷新本页面。
        let interval = -1 * TabTopicViewController.lastLeaveTime.timeIntervalSinceNow
        if interval > 120 {
            self.tableView.mj_header.beginRefreshing()
            self.message_count()
        }
    }
    @objc func applicationDidEnterBackground(){
        TabTopicViewController.lastLeaveTime = Date()
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
