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

class TabTopicViewController: UITableViewController, IndicatorInfoProvider {
    
    var tabText: String!
    var tab: String!
    
    var provider = MoyaProvider<CNodeService>()
    fileprivate var page = 1
    var data = [Topic]()
    
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 添加下拉刷新组件
        self.view.addSubview(refresh)
        self.refresh.addTarget(self, action: #selector(TabTopicViewController.refreshData), for: .valueChanged)
        self.tableView.refreshControl? = refresh
        
        // 添加加载更多组件
        self.tableView.mj_footer = LoadMoreView(refreshingBlock: {
            [weak self] () -> Void in
            self?.loadMoreData()
        })
        
        //加载数据
        self.refresh.beginRefreshing()
        refreshData()
    }
    
    @objc func refreshData() {
        self.page = 1
        provider.request(.topics(page: self.page, tab: self.tab)) { (res) in
            switch res {
            case .success(let response):
                self.page += 1
                let result = try! JSONDecoder().decode(Result<[Topic]>.self, from: response.data)
                self.data = result.data!
                self.refresh.endRefreshing()
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func loadMoreData() {
        provider.request(.topics(page: self.page, tab: self.tab)) { (res) in
            switch res {
            case .success(let response):
                self.page += 1
                let result = try! JSONDecoder().decode(Result<[Topic]>.self, from: response.data)
                self.data += result.data!
                self.tableView.mj_footer.endRefreshing()
                if result.data!.count < 50 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopicTableViewCell
        cell.bind(topic: data[indexPath.row])
        return cell
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
