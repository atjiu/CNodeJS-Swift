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
    
    var avatar: UIImageView = {
        let _avatar = UIImageView()
        _avatar.layer.masksToBounds = true
        _avatar.layer.cornerRadius = 18
        return _avatar
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var timeLabel: UILabel = {
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
        label.backgroundColor = UIColor(CNodeColor.tabColor)
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(avatar)
        self.addSubview(usernameLabel)
        self.addSubview(timeLabel)
        self.addSubview(titleLabel)
        self.addSubview(replyCountLabel)
        self.addSubview(viewLabel)
        self.addSubview(tabLabel)
        
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.top.left.equalTo(16)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(5)
            make.left.equalTo(self.avatar.snp.right).offset(10)
        }
        
        viewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        replyCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.viewLabel.snp.left)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        tabLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.top)
            make.right.equalTo(self.replyCountLabel.snp.left).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.right.bottom.equalTo(-16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(topic: Topic) {
        self.avatar.kf.setImage(with: URL(string: (topic.author?.avatar_url)!)!)
        self.usernameLabel.text = topic.author?.loginname
        self.timeLabel.text = "2小时前"
        self.viewLabel.text = " / \(topic.visit_count ?? 0)"
        self.replyCountLabel.text = String(topic.reply_count ?? 0)
        self.tabLabel.text = topic.tab
        self.titleLabel.text = topic.title
    }
}
