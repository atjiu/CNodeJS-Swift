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
import Moya
import WebKit

class TopicDetailViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var provider = MoyaProvider<CNodeService>()
    
    var topic: Topic!
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "AppModel")
        
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
    }

    func world(message: String) {
        print("message: \(message)")
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
        webView.loadHTMLString(TOPICDETAILHTML, baseURL: Bundle.main.resourceURL)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        provider.request(.topicDetail(id: topic.id!)) { (res) in
            switch res {
            case .success(let response):
                print(try! response.mapJSON())
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
//                let result = try! decoder.decode(Result<Topic>.self, from: response.data)
//                self.topic = result.data
//                self.reloadData()
                webView.evaluateJavaScript("init('\(response.data.description)')", completionHandler: { (res, err) in
                    print(res, err)
                })
            case .failure(let error):
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}
