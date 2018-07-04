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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TopicDetailTableViewCell.self, forCellReuseIdentifier: "detailCell")
        self.tableView.register(ReplyTableViewCell.self, forCellReuseIdentifier: "repliesCell")
        
        self.tableView.mj_header = RefreshView(refreshingBlock: {
            [weak self] () -> Void in
            self?.fetch()
        })
        self.tableView.mj_header.beginRefreshing()
        topicDetailView.isHidden = true
        self.tableView.tableHeaderView = topicDetailView
        topicDetailView.heightChange = {
            [weak self] (flag) in
            if flag {
                self?.tableView.reloadData()
            }
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
                self.topicDetailView.isHidden = false
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
