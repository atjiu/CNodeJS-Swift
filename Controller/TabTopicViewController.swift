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
import Toast_Swift

class TabTopicViewController: UITableViewController, IndicatorInfoProvider {
    
    var tabText: String!
    var tab: String!
    
    var provider = MoyaProvider<CNodeService>()
    fileprivate var page = 1
    var data = [Topic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
                self.view.makeToast(error.errorDescription)
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
                self.view.makeToast(error.errorDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopicTableViewCell
        cell.bind(topic: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = data[indexPath.row]
//        let topicDetailViewController = TopicDetailTableViewController()
        let topicDetailViewController = TopicDetailViewController()
        topicDetailViewController.topic = topic
        self.navigationController?.pushViewController(topicDetailViewController, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.tabText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
