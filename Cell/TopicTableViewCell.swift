//
//  TopicTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import UIColor_Hex_Swift

class TopicTableViewCell: UITableViewCell {
    
    var tabTopicViewController: TabTopicViewController!
    
    var avatar: UIImageView = {
        let _avatar = UIImageView()
        _avatar.layer.masksToBounds = true
        _avatar.layer.cornerRadius = 4
        return _avatar
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var createTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(CNodeColor.timeColor)
        return label
    }()
    var lastReplyTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(CNodeColor.timeColor)
        return label
    }()
    var replyCountLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(CNodeColor.tabColor)
        return label
    }()
    var viewLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(CNodeColor.timeColor)
        return label
    }()
    var tabLabel: UILabelPadding = {
        var label = UILabelPadding(withInsets: 0, 0, 3, 3)
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = UIColor(CNodeColor.grayColor)
        label.textColor = .gray
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    var topic: Topic?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(avatar)
        self.addSubview(usernameLabel)
        self.addSubview(createTimeLabel)
        self.addSubview(lastReplyTimeLabel)
        self.addSubview(titleLabel)
        self.addSubview(replyCountLabel)
        self.addSubview(viewLabel)
        self.addSubview(tabLabel)
        
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(32)
            make.top.left.equalTo(10)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(5)
            make.left.equalTo(self.avatar.snp.right).offset(10)
        }
        
        lastReplyTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.createTimeLabel.snp.right).offset(10)
            make.top.equalTo(self.createTimeLabel.snp.top)
        }
        
        viewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.tabLabel.snp.left).offset(-5)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        replyCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.viewLabel.snp.left)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        tabLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.top)
            make.right.equalTo(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        self.avatar.isUserInteractionEnabled = true
        self.avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TopicTableViewCell.toUserCenter)))
        self.usernameLabel.isUserInteractionEnabled = true
        self.usernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TopicTableViewCell.toUserCenter)))
    }
    
    //跳转用户页
    @objc func toUserCenter() {
        let userCenterViewController = UserCenterViewController()
        userCenterViewController.type = 1
        userCenterViewController.loginname = self.topic?.author?.loginname
        self.tabTopicViewController.navigationController?.pushViewController(userCenterViewController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(topic: Topic) {
        self.avatar.kf.setImage(with: URL(string: (topic.author?.avatar_url)!)!)
        self.usernameLabel.text = topic.author?.loginname
        self.createTimeLabel.text = "\(NSLocalizedString("topic_create_at", comment: ""))\((topic.create_at?.getElapsedInterval())!)"
        if topic.reply_count ?? 0 > 0 {
            self.lastReplyTimeLabel.text = "\(NSLocalizedString("topic_last_reply_at", comment: ""))\((topic.last_reply_at?.getElapsedInterval())!)"
        } else {
            self.lastReplyTimeLabel.text = ""
        }
        self.viewLabel.text = "/\(topic.visit_count ?? 0)"
        self.replyCountLabel.text = String(topic.reply_count ?? 0)
        // 格式化分类
        var _tab = NSLocalizedString("tab_share", comment: "");
        if topic.tab == "job" {
            _tab = NSLocalizedString("tab_job", comment: "")
        } else if topic.tab == "ask" {
            _tab = NSLocalizedString("tab_ask", comment: "")
        } else if topic.tab == "blog" {
            _tab = NSLocalizedString("tab_blog", comment: "")
        } else if topic.tab == "share" {
            _tab = NSLocalizedString("tab_share", comment: "")
        } else if topic.tab == "dev" {
            _tab = NSLocalizedString("tab_dev", comment: "")
        }
        if topic.good ?? false {
            _tab = NSLocalizedString("tab_good", comment: "")
        }
        if topic.top ?? false {
            _tab = NSLocalizedString("tab_top", comment: "")
        }
        if topic.good ?? false || topic.top ?? false {
            self.tabLabel.backgroundColor = UIColor(CNodeColor.tabColor)
            self.tabLabel.textColor = UIColor.white
        } else {
            self.tabLabel.backgroundColor = UIColor(CNodeColor.grayColor)
            self.tabLabel.textColor = .gray
        }
        self.tabLabel.text = _tab
        self.titleLabel.text = topic.title
        
        self.topic = topic
    }
    
}
