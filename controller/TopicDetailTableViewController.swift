//
//  TopicDetailTableViewController.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/7/4.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import YYText
import Toast_Swift

class TopicDetailTableViewController: UITableViewController {
    
    var provider = MoyaProvider<CNodeService>()
    var topic: Topic!
    let topicDetailView = TopicDetailTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        //添加菜单
        let menuButton = UIButton()
        menuButton.contentMode = .center
        menuButton.setImage(UIImage(named: "baseline_menu_white_24pt"), for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuButton.addTarget(self, action: #selector(TopicDetailTableViewController.menuClick), for: .touchUpInside)
        
        self.tableView.register(ReplyTableViewCell.self, forCellReuseIdentifier: "repliesCell")
        
        self.tableView.mj_header = RefreshView(refreshingBlock: {
            [weak self] () -> Void in
            self?.fetch()
        })
        self.tableView.mj_header.beginRefreshing()
        topicDetailView.heightChange = {
            [weak self] (flag) in
            if flag {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func menuClick() {
        let alertController = UIAlertController(title: "Hello World", message: "WebView这么难用，那么Safari是怎么开发出来的呢？", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "收藏", style: .default, handler: self.collectHandler))
        alertController.addAction(UIAlertAction(title: "分享", style: .default, handler: self.shareHandler))
        alertController.addAction(UIAlertAction(title: "回复", style: .default, handler: self.replyHandler))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            print(111)
        } else {
            self.view.makeToast("请先登录", duration: 2, position: .center)
        }
    }
    
    func shareHandler(alert: UIAlertAction) {
        let shareUrl = URL.init(string: "\(BASE_URL)/topic/\(topic.id!)")
        let shareArr = [shareUrl!]
        let activityController = UIActivityViewController.init(activityItems: shareArr, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    func replyHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            print(222)
        } else {
            self.view.makeToast("请先登录", duration: 2, position: .center)
        }
    }
    
    func fetch() {
        provider.request(.topicDetail(id: topic.id!)) { (res) in
            switch res {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try! decoder.decode(Result<Topic>.self, from: response.data)
                self.topic = result.data
                self.tableView.mj_header.endRefreshing()
                self.topicDetailView.bind(topic: self.topic)
                self.tableView.tableHeaderView = self.topicDetailView
                self.tableView.reloadData()
            case .failure(let error):
                self.view.makeToast(error.errorDescription)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topic.replies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repliesCell", for: indexPath) as! ReplyTableViewCell
        cell.bind(reply: (topic!.replies?[indexPath.row])!, position: indexPath.row)
        return cell
    }

}
