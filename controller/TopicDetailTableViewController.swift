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
                self.tableView.reloadData()
            case .failure(let error):
                self.view.makeToast(error.errorDescription)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.topic.replies?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
            let headerTitle = UILabel()
            headerTitle.font = UIFont.systemFont(ofSize: 14)
            headerTitle.text = "\(self.topic.reply_count ?? 0)条回复"
            view.addSubview(headerTitle)
            view.backgroundColor = UIColor(CNodeColor.grayColor)
            headerTitle.snp.makeConstraints { (make) in
                make.top.left.equalTo(10)
                make.bottom.right.equalTo(-10)
            }
            return view
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! TopicDetailTableViewCell
            cell.bind(topic: topic)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repliesCell", for: indexPath) as! ReplyTableViewCell
            cell.bind(reply: (topic!.replies?[indexPath.row])!, position: indexPath.row)
            return cell
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
