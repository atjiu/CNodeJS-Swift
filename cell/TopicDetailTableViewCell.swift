//
//  TopicDetailTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/7/1.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import WebKit

class TopicDetailTableViewCell: UITableViewCell, WKNavigationDelegate {
    
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
    
    var contentWebView: WKWebView = {
        var webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    var starImage: UIButton = {
        var button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "baseline_star_border_black_24pt"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(TopicDetailTableViewCell.starClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    @objc func starClick() {
        print(11)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(avatar)
        self.addSubview(usernameLabel)
        self.addSubview(createTimeLabel)
        self.addSubview(titleLabel)
        self.addSubview(viewLabel)
        self.addSubview(tabLabel)
        self.addSubview(starImage)
        self.addSubview(contentWebView)
        
        self.contentWebView.navigationDelegate = self
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.equalToSuperview().offset(-10)
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
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.avatar.snp.top).offset(5)
            make.width.height.equalTo(24)
        }
        
        contentWebView.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(1)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let height = webView.scrollView.contentSize.height
        print(height)
        self.contentWebView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(topic: Topic) {
        self.avatar.kf.setImage(with: URL(string: (topic.author?.avatar_url)!)!)
        self.usernameLabel.text = topic.author?.loginname
        self.createTimeLabel.text = "创建于 " + (topic.create_at?.getElapsedInterval())!
        self.viewLabel.text = "/\(topic.visit_count ?? 0)次浏览"
        self.tabLabel.text = topic.tab
        self.titleLabel.text = topic.title
        let content = "<html><head><style>.markdown-text{font-size: 16px;}img{max-width: 100%;}</style></head><body>\(topic.content!)</body></html>"
        self.contentWebView.loadHTMLString(content, baseURL: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
