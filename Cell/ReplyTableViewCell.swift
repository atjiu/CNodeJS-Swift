//
//  ReplyTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/2.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import YYText

class ReplyTableViewCell: UITableViewCell {
    
    var avatar: UIImageView = {
        let _avatar = UIImageView()
        _avatar.layer.masksToBounds = true
        _avatar.layer.cornerRadius = 18
        return _avatar
    }()
    var usernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var createTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(CNodeColor.timeColor)
        return label
    }()
    var positionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(CNodeColor.tabColor)
        return label
    }()
    var upLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(CNodeColor.timeColor)
        return label
    }()
    var upImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "baseline_thumb_up_black_24pt")
        return image
    }()
    var replyImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "baseline_reply_black_24pt")
        return image
    }()
    var contentLabel: YYLabel = {
        var label = YYLabel()
        label.numberOfLines = 0
        label.displaysAsynchronously = true
        label.preferredMaxLayoutWidth = SCREEN_WIDTH
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(avatar)
        self.addSubview(usernameLabel)
        self.addSubview(createTimeLabel)
        self.addSubview(positionLabel)
        self.addSubview(upLabel)
        self.addSubview(upImage)
        self.addSubview(replyImage)
        self.addSubview(contentLabel)
        
        avatar.snp.makeConstraints { (make) in
            make.top.left.equalTo(16)
            make.width.height.equalTo(36)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.top.equalTo(self.avatar.snp.top)
        }
        positionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameLabel.snp.left)
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(5)
        }
        createTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.positionLabel.snp.top)
            make.left.equalTo(self.positionLabel.snp.right).offset(5)
        }
        replyImage.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(self.avatar.snp.top)
            make.width.height.equalTo(16)
        }
        upLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.replyImage.snp.left).offset(-10)
            make.top.equalTo(self.avatar.snp.top)
        }
        upImage.snp.makeConstraints { (make) in
            make.right.equalTo(self.upLabel.snp.left).offset(-10)
            make.top.equalTo(self.avatar.snp.top)
            make.width.height.equalTo(16)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatar.snp.left)
            make.right.equalTo(-10)
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    func bind(reply: Reply, position: Int) {
        avatar.kf.setImage(with: URL(string: (reply.author?.avatar_url!)!))
        usernameLabel.text = reply.author?.loginname
        positionLabel.text = "\(position + 1)楼"
        createTimeLabel.text = reply.create_at?.getElapsedInterval()
        upLabel.text = String(reply.ups?.count ?? 0)
        var content = "<html><head>"+VIEWPORT+"<style>"+CSS+"img{max-width: 100%;}</style></head><body>\(reply.content!.trimmingCharacters(in: CharacterSet.newlines))</body></html>"
        content = content.replacingOccurrences(of: "//dn-cnode.qbox.me", with: "https://dn-cnode.qbox.me")
        content = content.replacingOccurrences(of: "\n</div>", with: "</div>")
        contentLabel.textLayout = YYTextLayout(containerSize: CGSize(width: SCREEN_WIDTH-24, height: 9999), text: content.htmlToAttributedString!)
        contentLabel.attributedText = content.htmlToAttributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
