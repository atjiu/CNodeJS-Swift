//
//  NotificationTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/26.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class NotificationTableViewCell: UITableViewCell {
    
    var avatar: UIImageView = {
        var image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        return image
    }()
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var timeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var statusLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var descLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    var titleLabel: UILabelPadding = {
        var label = UILabelPadding(withInsets: 7,7,7,7)
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // 装上面定义的那些元素的容器
    var contentPanel = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.contentView.addSubview(self.contentPanel)
        self.contentPanel.addSubview(avatar)
        self.contentPanel.addSubview(usernameLabel)
        self.contentPanel.addSubview(timeLabel)
        self.contentPanel.addSubview(statusLabel)
        self.contentPanel.addSubview(descLabel)
        self.contentPanel.addSubview(titleLabel)
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.usernameLabel.textColor = AppColor.colors.usernameColor
            self?.timeLabel.textColor = AppColor.colors.timeColor
            self?.statusLabel.textColor = AppColor.colors.usernameColor
            self?.descLabel.textColor = AppColor.colors.timeColor
            self?.titleLabel.backgroundColor = AppColor.colors.backgroundColor
            self?.titleLabel.textColor = AppColor.colors.titleColor
            self?.contentPanel.backgroundColor = AppColor.colors.cellBackgroundColor
            self?.backgroundColor = AppColor.colors.backgroundColor
            selectedBackgroundView.backgroundColor = AppColor.colors.backgroundColor
        }
        
        contentPanel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-8)
        }
        
        avatar.snp.makeConstraints { (make) in
            make.top.left.equalTo(16)
            make.width.height.equalTo(32)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.top.equalTo(avatar.snp.top)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(avatar.snp.bottom)
            make.left.equalTo(usernameLabel.snp.left)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.top)
            make.right.equalTo(-16)
        }
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatar.snp.left)
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.right.equalTo(statusLabel.snp.right)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.left.equalTo(avatar.snp.left)
            make.right.equalTo(statusLabel.snp.right)
            make.bottom.equalTo(-16)
        }
    }
    
    func bind(_ message: Message) {
        avatar.kf.setImage(with: URL(string: message.author.avatar_url!))
        usernameLabel.text = message.author.loginname
        timeLabel.text = message.reply.create_at?.getElapsedInterval()
        if message.has_read {
            statusLabel.textColor = AppColor.colors.usernameColor
        } else {
            statusLabel.textColor = AppColor.colors.tabColor
        }
        statusLabel.text = message.has_read ? NSLocalizedString("read", comment: "") : NSLocalizedString("unread", comment: "")
        switch message.type {
        case "at":
            descLabel.text = "\(message.author.loginname!)\(NSLocalizedString("note_at_msg", comment: ""))"
        case "reply":
            descLabel.text = "\(message.author.loginname!)\(NSLocalizedString("note_reply_msg", comment: ""))"
        default:
            print("")
        }
        titleLabel.text = message.topic.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
