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

class UserTopicsTableViewCell: UITableViewCell {
    
    var avatar: UIImageView = {
        let _avatar = UIImageView()
        _avatar.layer.masksToBounds = true
        _avatar.layer.cornerRadius = 4
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
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    var createTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(CNodeColor.timeColor)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(avatar)
        self.addSubview(usernameLabel)
        self.addSubview(createTimeLabel)
        self.addSubview(titleLabel)
        
        avatar.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
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
