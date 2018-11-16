//
//  UserHeaderTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/11.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Moya
import SwiftyJSON

class UserHeaderTableViewCell: UITableViewCell {
    
    let provider = MoyaProvider<CNodeService>()
    // 0: 当前用户的个人中心 1: 其它用户的个人中心
    var type: Int!
    var author: Author!
    
    lazy var avatar: UIImageView = {
        var avatar = UIImageView()
        avatar.image = UIImage(named: "not_login_user_avatar")
        avatar.layer.cornerRadius = 51
        avatar.layer.masksToBounds = true
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "user_detail_header_bg")!)
        self.addSubview(avatar)
        self.addSubview(username)
        self.addSubview(registerTime)
        self.addSubview(score)
        
        addConstraints()
        
        // 添加事件
        self.avatar.isUserInteractionEnabled = true
        self.avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserHeaderTableViewCell.avatarTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        avatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        username.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        registerTime.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(self.username.snp.bottom).offset(30)
            make.bottom.equalTo(-10)
        }
        
        score.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(self.username.snp.bottom).offset(30)
            make.bottom.equalTo(-10)
        }
    }
    
    func bind() {
        if type == 0 {
            if UserDefaults.standard.string(forKey: "token") != nil {
                let avatar_url = UserDefaults.standard.string(forKey: "avatar_url")
                let username = UserDefaults.standard.string(forKey: "loginname")
                let create_at = UserDefaults.standard.string(forKey: "create_at")
                let score = UserDefaults.standard.string(forKey: "score")
                if avatar_url != nil {
                    self.avatar.kf.setImage(with: URL(string: avatar_url!))
                }
                if username != nil {
                    self.username.text = username
                }
                if create_at != nil {
                    self.registerTime.text = "\(NSLocalizedString("user_header_sign_in", comment: ""))" + create_at!
                }
                if score != nil {
                    self.score.text = "\(NSLocalizedString("user_header_score", comment: ""))\(score!)"
                }
            } else {
                self.username.text = NSLocalizedString("user_header_scanner_tip", comment: "")
            }
        } else if type == 1 {
            self.avatar.kf.setImage(with: URL(string: author.avatar_url!))
            self.username.text = author.loginname
            self.registerTime.text = "\(NSLocalizedString("user_header_sign_in", comment: ""))\((author.create_at?.getElapsedInterval())!)"
            self.score.text = "\(NSLocalizedString("user_header_score", comment: ""))\(author.score!)"
        }
    }
    
    func unbind() {
        self.avatar.image = UIImage(named: "not_login_user_avatar")
        self.username.text = NSLocalizedString("user_header_scanner_tip", comment: "")
        self.registerTime.text = ""
        self.score.text = ""
    }
    
    var toLogin: (() -> Void)?
    
    @objc func avatarTap() {
        if UserDefaults.standard.string(forKey: "token") == nil {
            self.toLogin?()
        }
    }
    
}
