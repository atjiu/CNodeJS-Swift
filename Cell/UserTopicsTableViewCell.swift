//
//  UserTopicsTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/13.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import NightNight

class UserTopicsTableViewCell: UITableViewCell {
    
    var avatar: UIImageView = {
        let _avatar = UIImageView()
        _avatar.layer.masksToBounds = true
        _avatar.layer.cornerRadius = 4
        return _avatar
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.mixedTextColor = MixedColor(normal: UIColor(CNodeColor.titleColor), night: UIColor(CNodeColor.titleColor_dark))
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.mixedTextColor = MixedColor(normal: UIColor(CNodeColor.usernameColor), night: UIColor(CNodeColor.usernameColor_dark))
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var createTimeLabel: UILabel = {
        var label = UILabel()
        label.mixedTextColor = MixedColor(normal: UIColor(CNodeColor.timeColor), night: UIColor(CNodeColor.timeColor_dark))
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // 装上面定义的那些元素的容器
    var contentPanel:UIView = {
        var contentPanel = UIView()
        contentPanel.mixedBackgroundColor = MixedColor(normal: UIColor(CNodeColor.cellBackgroundColor), night: UIColor(CNodeColor.cellBackgroundColor_dark))
        return contentPanel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.mixedBackgroundColor = MixedColor(normal: UIColor(CNodeColor.backgroundColor), night: UIColor(CNodeColor.backgroundColor_dark))
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
        selectedBackgroundView.mixedBackgroundColor = MixedColor(normal: UIColor(CNodeColor.backgroundColor), night: UIColor(CNodeColor.backgroundColor_dark))
        
        self.contentView.addSubview(self.contentPanel)
        
        self.contentPanel.addSubview(avatar)
        self.contentPanel.addSubview(usernameLabel)
        self.contentPanel.addSubview(createTimeLabel)
        self.contentPanel.addSubview(titleLabel)
        
        contentPanel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-8)
        }
        
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.left.equalTo(10)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.top.equalTo(self.avatar.snp.top)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameLabel.snp.top)
            make.right.equalTo(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
    }
    
    func bind(_ topic: Topic) {
        self.titleLabel.text = topic.title
        self.usernameLabel.text = topic.author?.loginname
        self.createTimeLabel.text = topic.last_reply_at?.getElapsedInterval()
        self.avatar.kf.setImage(with: URL(string: (topic.author?.avatar_url)!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
