//
//  UserViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Toast_Swift

class UserViewController: UITableViewController {
    
    lazy var headerView: UITableViewCell = {
        var view = UITableViewCell()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "user_detail_header_bg")!)
        return view
    }()
    
    lazy var avatar: UIImageView = {
        var avatar = UIImageView()
        avatar.image = UIImage(named: "baseline_account_circle_white_24pt")
        return avatar
    }()
    
    var username: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var registerTime: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    var score: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(CNodeColor.tabColor)
        return label
    }()
    
    var data = [
        ("", []),
        ("", [
            ("baseline_account_circle_black_24pt","个人中心"),
            ("baseline_view_list_black_24pt","我的话题"),
            ("baseline_reply_all_black_24pt","我的回复"),
            ("baseline_collections_bookmark_black_24pt","我的收藏"),
            ("baseline_settings_black_24pt","设置")
        ]),
        ("", [("baseline_warning_white_24pt","登出")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "我"
        self.view.backgroundColor = UIColor(CNodeColor.grayColor)
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        addView()
        addConstraints()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logoutCell")
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = footerView
    }
    
    func  addView() {
        self.headerView.addSubview(avatar)
        self.headerView.addSubview(username)
        self.headerView.addSubview(registerTime)
        self.headerView.addSubview(score)
        
        self.tableView.addSubview(headerView)
    }
    
    func addConstraints() {
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(200)
        }
        avatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(72)
        }
        
        username.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        registerTime.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(self.username.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        score.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(self.username.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [200, 0, 20][section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
            if indexPath.section == 2 {
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.red
            }
            cell.textLabel?.text = data[indexPath.section].1[indexPath.row].1
            cell.imageView?.image = UIImage(named: data[indexPath.section].1[indexPath.row].0)
            return cell
        }
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
