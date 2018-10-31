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
import SwiftyJSON
import Toast_Swift

class TopicDetailWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var provider = MoyaProvider<CNodeService>()
    
    var topic: Topic!
    var detail_reply_id: String?
    var detail_reply_loginname: String?
    
    var refreshControl = UIRefreshControl()
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "AppModel")
        
        var webView = WKWebView(frame: .zero, configuration: configuration)
//        webView.layer.borderColor = UIColor.red.cgColor
//        webView.layer.borderWidth = 1
//        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        webView.loadHTMLString(TOPICDETAILHTML, baseURL: Bundle.main.resourceURL)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        //添加菜单
        let menuButton = UIButton()
        menuButton.contentMode = .center
        menuButton.setImage(UIImage(named: "baseline_menu_white_24pt"), for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuButton.addTarget(self, action: #selector(TopicDetailWebViewController.menuClick), for: .touchUpInside)

        //给scrollView添加下拉刷新
        self.refreshControl.addTarget(self, action: #selector(TopicDetailWebViewController.fetch), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
        
        self.refreshControl.beginRefreshing()

        addSubView()
        addConstraints()
        
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
    
    @objc func fetch() {
        //刷新页面
        provider.request(.topicDetail(id: topic.id!)) { (res) in
            switch res {
            case .success(let response):
                self.refreshControl.endRefreshing()
                let topicJson = JSON(response.data)
                var topicJsonStr = topicJson.rawString();
                topicJsonStr = topicJsonStr?.replacingOccurrences(of: "\n", with: "")
                topicJsonStr = topicJsonStr?.replacingOccurrences(of: "\\/\\/static.cnodejs.org", with: "https:\\/\\/static.cnodejs.org")
                self.webView.evaluateJavaScript("init(\(topicJsonStr!))", completionHandler: { (res, err) in
                    //                    print(11, res, err)
                })
            case .failure(let error):
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }
    
    @objc func menuClick() {
        let alertController = UIAlertController(title: "Hello World", message: "WebView加载HTML才是王道", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "回复", style: .default, handler: self.replyHandler))
        alertController.addAction(UIAlertAction(title: "分享", style: .default, handler: self.shareHandler))
        alertController.addAction(UIAlertAction(title: "收藏", style: .default, handler: self.collectHandler))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func replyClick() {
        let alertController = UIAlertController(title: "Hello World", message: "你想干点啥", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "回复", style: .default, handler: self.replyHandler))
        alertController.addAction(UIAlertAction(title: "点赞", style: .default, handler: self.upHandler))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func upHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            self.view.makeToastActivity(.center)
            provider.request(.up(self.detail_reply_id!, UserDefaults.standard.string(forKey: "token")!)) { (res) in
                switch res {
                case .success(_):
                    self.view.hideToastActivity()
                    self.view.makeToast("点赞成功!")
                case .failure(let error):
                    UIAlertController.showAlert(message: error.errorDescription!)
                }
            }
        } else {
            UIAlertController.showAlert(message: "请先登录!")
        }
    }
    
    func collectHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            self.view.makeToastActivity(.center)
            provider.request(.favorite(UserDefaults.standard.string(forKey: "token")!, self.topic.id!)) { (res) in
                switch res {
                case .success(_):
                    self.view.hideToastActivity()
                    self.view.makeToast("收藏成功!")
                case .failure(let error):
                    UIAlertController.showAlert(message: error.errorDescription!)
                }
            }
        } else {
            UIAlertController.showAlert(message: "请先登录!")
        }
    }
    
    func shareHandler(alert: UIAlertAction) {
        let shareUrl = URL.init(string: "\(BASE_URL)/topic/\(topic.id!)")
        let shareArr = [shareUrl!]
        let activityController = UIActivityViewController.init(activityItems: shareArr, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    func replyHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            let addReplyViewController = AddReplyViewController();
            addReplyViewController.topic_id = topic.id!
            addReplyViewController.reply_id = detail_reply_id
            addReplyViewController.detail_reply_loginname = detail_reply_loginname
            present(UINavigationController(rootViewController: addReplyViewController), animated: true, completion: nil)
        } else {
            UIAlertController.showAlert(message: "请先登录")
        }
    }

    func world(message: String) {
        print("message: \(message)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        fetch();
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body, type(of: message.body))
        let msg = JSON(parseJSON: message.body as! String)
        if (msg["type"] == "click_reply") {
            detail_reply_id = msg["reply_id"].rawString()
            detail_reply_loginname = msg["loginname"].rawString()
            replyClick()
        }
    }
}
