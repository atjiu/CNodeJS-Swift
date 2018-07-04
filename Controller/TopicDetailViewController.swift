//
//  TopicDetailViewController.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/6/30.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Toast_Swift
import Moya

class TopicDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var provider = MoyaProvider<CNodeService>()
    
    var topic: Topic!
    var replies = [Reply]()
    
    var avatar: UIImageView = {
        let _avatar = UIImageView()
        _avatar.layer.masksToBounds = true
        _avatar.layer.cornerRadius = 18
        return _avatar
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
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
    
    var topicDetailView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = true
        return scroll
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
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReplyTableViewCell.self, forCellReuseIdentifier: "repliesCell")
        tableView.isScrollEnabled = false
        tableView.layer.borderColor = UIColor.red.cgColor
        tableView.layer.borderWidth = 1
        return tableView
    }()
    
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        //给scrollView添加下拉刷新
        self.scrollView.refreshControl = refresh
        self.refresh.addTarget(self, action: #selector(TopicDetailViewController.fetch), for: .valueChanged)
        
        addSubView()
        addConstraints()
        
        self.refresh.beginRefreshing()
        fetch()
        
    }
    
    override var preferredContentSize: CGSize {
        get {
            self.tableView.layoutIfNeeded()
            return self.tableView.contentSize
        }
        set {}
    }
    
    @objc func fetch() {
        provider.request(.topicDetail(id: topic.id!)) { (res) in
            switch res {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try! decoder.decode(Result<Topic>.self, from: response.data)
                self.topic = result.data
                self.replies = self.topic.replies!
                self.bind()
                self.tableView.reloadData()
                self.updateConstraints(height: 0)
                self.refresh.endRefreshing()
                self.showView()
            case .failure(let error):
                self.view.makeToast(error.errorDescription)
            }
        }
    }
    
    func addSubView() {
        topicDetailView.addSubview(avatar)
        topicDetailView.addSubview(usernameLabel)
        topicDetailView.addSubview(createTimeLabel)
        topicDetailView.addSubview(titleLabel)
        topicDetailView.addSubview(viewLabel)
        topicDetailView.addSubview(tabLabel)
        topicDetailView.addSubview(starImage)
        topicDetailView.addSubview(contentWebView)
        
        tableHeaderView.addSubview(tableHeaderTitle)
        topicDetailView.addSubview(tableHeaderView)
        
        scrollView.addSubview(topicDetailView)
        scrollView.addSubview(tableView)
        
        self.view.addSubview(scrollView)
        self.hideView()
    }
    
    func hideView() {
        self.topicDetailView.isHidden = true
        self.tableView.isHidden = true
    }
    
    func showView() {
        self.topicDetailView.isHidden = false
        self.tableView.isHidden = false
    }
    
    func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        topicDetailView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.size.width)
        }
        
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
            make.height.equalTo(1)
        }
        
        tableHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentWebView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tableHeaderTitle.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.tableHeaderView.snp.bottom)
        }
    }
    
    func bind() {
        avatar.kf.setImage(with: URL(string: (topic.author?.avatar_url)!)!)
        usernameLabel.text = topic.author?.loginname
        createTimeLabel.text = "创建于 " + (topic.create_at?.getElapsedInterval())!
        viewLabel.text = "/\(topic.visit_count ?? 0)次浏览"
        tabLabel.text = topic.tab
        titleLabel.text = topic.title
        tableHeaderTitle.text = "\(self.topic.reply_count ?? 0)条回复"
        
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        if keyPath == "contentSize" {
            updateConstraints(height: contentWebView.scrollView.contentSize.height)
        }
    }
    
    func updateConstraints(height: CGFloat) {
        print("height: \(height)")
        contentWebView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
        let topicDetailViewHeight = 10 + self.titleLabel.bounds.size.height + 10 + self.avatar.bounds.size.height + height + 10 + self.tableHeaderView.bounds.size.height
        
        topicDetailView.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(topicDetailViewHeight)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: topicDetailViewHeight + self.preferredContentSize.height)
        
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topicDetailView.snp.bottom)
            make.height.equalTo(self.preferredContentSize.height)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repliesCell", for: indexPath) as! ReplyTableViewCell
        cell.bind(reply: replies[indexPath.row], position: indexPath.row + 1)
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
