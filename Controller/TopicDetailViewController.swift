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
import WebKit

class TopicDetailViewController: UIViewController, WKNavigationDelegate {
    
    var provider = MoyaProvider<CNodeService>()
    
    var topic: Topic!
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        var webView = WKWebView(frame: .zero, configuration: configuration)
        webView.layer.borderColor = UIColor.red.cgColor
        webView.layer.borderWidth = 1
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        return webView
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
//        self.scrollView.refreshControl = refresh
//        self.refresh.addTarget(self, action: #selector(TopicDetailViewController.fetch), for: .valueChanged)
        
        addSubView()
        addConstraints()
        
        fetch()
    }
    
    func world(message: String) {
        print("message: \(message)")
    }
    
    @objc func fetch() {
        provider.request(.topicDetail(id: topic.id!)) { (res) in
            switch res {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try! decoder.decode(Result<Topic>.self, from: response.data)
                self.topic = result.data
                self.reloadData()
            case .failure(let error):
                self.view.makeToast(error.errorDescription)
            }
        }
    }
    
    func addSubView() {
        self.view.addSubview(webView)
    }
    
    func addConstraints() {
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(64)
        }
    }
    
    func reloadData() {
        webView.loadHTMLString(TOPICDETAILHTML, baseURL: nil)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("hello('\(topic.title!)')", completionHandler: { (res, err) in
            print(res, err)
        })
    }
    
}