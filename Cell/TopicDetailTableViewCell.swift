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
import YYText
import WebKit

class TopicDetailTableViewCell: UITableViewCell {
    
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
    var createTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(CNodeColor.timeColor)
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
    
    lazy var contentWebView: UIWebView = {
        var webView = UIWebView()
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        return webView
    }()
    
    var starImage: UIButton = {
        var button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "baseline_star_border_black_24pt"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(TopicDetailViewController.starClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    var tableHeaderTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var tableHeaderView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(CNodeColor.tableViewHeaderColor)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(avatar)
        self.addSubview(usernameLabel)
        self.addSubview(createTimeLabel)
        self.addSubview(titleLabel)
        self.addSubview(viewLabel)
        self.addSubview(tabLabel)
        self.addSubview(starImage)
        self.addSubview(contentWebView)
        
        self.tableHeaderView.addSubview(self.tableHeaderTitle)
        self.addSubview(tableHeaderView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.equalTo(-10)
        }
        
        avatar.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.width.height.equalTo(36)
        }
        
        tabLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.top)
            make.left.equalTo(self.avatar.snp.right).offset(10)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.top)
            make.left.equalTo(self.tabLabel.snp.right).offset(5)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.tabLabel.snp.bottom).offset(5)
            make.left.equalTo(self.tabLabel.snp.left)
        }
        
        viewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.createTimeLabel.snp.right).offset(5)
            make.top.equalTo(self.createTimeLabel.snp.top)
        }
        
        starImage.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(self.avatar.snp.top).offset(5)
            make.width.height.equalTo(24)
        }
        
        contentWebView.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.left.equalTo(self.avatar.snp.left)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        tableHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentWebView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tableHeaderTitle.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(topic: Topic) {
        avatar.kf.setImage(with: URL(string: (topic.author?.avatar_url)!)!)
        usernameLabel.text = topic.author?.loginname
        createTimeLabel.text = "创建于 " + (topic.create_at?.getElapsedInterval())!
        viewLabel.text = "/\(topic.visit_count ?? 0)次浏览"
        tabLabel.text = topic.tab
        titleLabel.text = topic.title
        tableHeaderTitle.text = "\(topic.reply_count ?? 0)条回复"
        var content = "<html><head>"+VIEWPORT+"<style>"+CSS+"img{max-width: 100%;}</style></head><body>\(topic.content!)</body></html>"
        content = content.replacingOccurrences(of: "//dn-cnode.qbox.me", with: "https://dn-cnode.qbox.me")
        content = content.replacingOccurrences(of: "\n</div>", with: "</div>")
        contentWebView.loadHTMLString(content, baseURL: nil)
    }
    
    var star = false
    @objc func starClick() {
        if star {
            starImage.setImage(UIImage(named: "baseline_star_border_black_24pt"), for: .normal)
            star = false
        } else {
            starImage.setImage(UIImage(named: "baseline_star_black_24pt"), for: .normal)
            star = true
        }
    }
    var heightChange: ( (_ flag: Bool) -> Void )?
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        if keyPath == "contentSize" {
            updateConstraints(height: contentWebView.scrollView.contentSize.height)
            heightChange?(true)
        }
    }

    func updateConstraints(height: CGFloat) {
        print("height: \(height)")
        let topicDetailHeight = 10 + self.titleLabel.bounds.size.height + 10 + self.avatar.bounds.size.height + 10 + height + self.tableHeaderView.bounds.size.height
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: topicDetailHeight)
        self.contentWebView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
}
