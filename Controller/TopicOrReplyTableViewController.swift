//
//  TopicOrReplyTableViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/13.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TopicOrReplyTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var tabTitle: String!
    var data = [Topic]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UserTopicsTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func reloadData(_ topics: [Topic]) {
        self.data = topics
        self.tableView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
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

}
