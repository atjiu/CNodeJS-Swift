//
//  TopicDetailViewController.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/6/30.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Toast_Swift

class TopicDetailViewController: UITableViewController {
    
    var topic: Topic!
    var data = [1,2,3,4,5,6]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "repliesCell")
        self.tableView.register(TopicDetailTableViewCell.self, forCellReuseIdentifier: "topicCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return data.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0, 40][section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let repliesHeaderView = UIView()
            repliesHeaderView.backgroundColor = UIColor(CNodeColor.grayColor)
            let repliesHeaderLabel = UILabel()
            repliesHeaderLabel.font = UIFont.systemFont(ofSize: 14)
            repliesHeaderLabel.text = "\(topic.reply_count ?? 0)条回复"
            repliesHeaderView.addSubview(repliesHeaderLabel)
            repliesHeaderLabel.snp.makeConstraints { (make) in
                make.top.left.equalTo(10)
                make.bottom.equalTo(-10)
            }
            return repliesHeaderView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! TopicDetailTableViewCell
            cell.bind(topic: topic)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repliesCell", for: indexPath)
            cell.textLabel?.text = String(data[indexPath.row])
            return cell
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
