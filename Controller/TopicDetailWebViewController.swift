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
import YBImageBrowser

class TopicDetailWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var provider = MoyaProvider<CNodeService>()
    
    var topic_id: String!
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
        self.title = NSLocalizedString("topic_detail", comment: "")
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        //添加菜单
        let menuButton = UIButton()
        menuButton.contentMode = .center
        menuButton.setImage(UIImage(named: "baseline_more_vert_white_24pt"), for: UIControlState.normal)
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
            make.top.equalTo(NavigationBarHeight)
        }
    }
    
    @objc func fetch() {
        //刷新页面
        provider.request(.topicDetail(id: self.topic_id)) { (res) in
            switch res {
            case .success(let response):
                self.refreshControl.endRefreshing()
                let topicJson = JSON(response.data)
                var topicJsonStr = topicJson.rawString();
                topicJsonStr = topicJsonStr?.replacingOccurrences(of: "\n", with: "")
                topicJsonStr = topicJsonStr?.replacingOccurrences(of: "\\/\\/static.cnodejs.org", with: "https:\\/\\/static.cnodejs.org")
                self.webView.evaluateJavaScript("init(\(topicJsonStr!))", completionHandler: { (res, err) in
                    //print(11, res, err)
                })
            case .failure(let error):
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }
    
    @objc func menuClick() {
//        let alertController = UIAlertController(title: "Hello World", message: "WebView加载HTML才是王道", preferredStyle: .actionSheet)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_reply", comment: ""), style: .default, handler: self.replyHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_share", comment: ""), style: .default, handler: self.shareHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_collect", comment: ""), style: .default, handler: self.collectHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func replyClick() {
//        let alertController = UIAlertController(title: "Hello World", message: "你想干点啥", preferredStyle: .actionSheet)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_reply", comment: ""), style: .default, handler: self.replyHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_up", comment: ""), style: .default, handler: self.upHandler))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("topic_cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func upHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            self.view.makeToastActivity(.center)
            provider.request(.up(self.detail_reply_id!, UserDefaults.standard.string(forKey: "token")!)) { (res) in
                switch res {
                case .success(_):
                    self.view.hideToastActivity()
                    self.navigationController?.view.makeToast(NSLocalizedString("alert_success", comment: ""))
                case .failure(let error):
                    UIAlertController.showAlert(message: error.errorDescription!)
                }
            }
        } else {
            UIAlertController.showAlert(message: NSLocalizedString("my_login_tip", comment: ""))
        }
    }
    
    func collectHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            self.view.makeToastActivity(.center)
            provider.request(.favorite(UserDefaults.standard.string(forKey: "token")!, self.topic_id)) { (res) in
                switch res {
                case .success(_):
                    self.view.hideToastActivity()
                    self.navigationController?.view.makeToast(NSLocalizedString("alert_success", comment: ""))
                case .failure(let error):
                    UIAlertController.showAlert(message: error.errorDescription!)
                }
            }
        } else {
            UIAlertController.showAlert(message: NSLocalizedString("my_login_tip", comment: ""))
        }
    }
    
    func shareHandler(alert: UIAlertAction) {
        let shareUrl = URL.init(string: "\(BASE_URL)/topic/\(self.topic_id!)")
        let shareArr = [shareUrl!]
        let activityController = UIActivityViewController.init(activityItems: shareArr, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    func replyHandler(alert: UIAlertAction) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            let addReplyViewController = AddReplyViewController();
            addReplyViewController.topic_id = self.topic_id
            addReplyViewController.reply_id = detail_reply_id
            addReplyViewController.detail_reply_loginname = detail_reply_loginname
            // 回复成功被调用用来显示toast
            addReplyViewController.reply_success = {[weak self] in
                self?.navigationController?.view.makeToast(NSLocalizedString("alert_success", comment: ""))
                self?.refreshControl.beginRefreshing()
                self?.fetch()
            }
            present(UINavigationController(rootViewController: addReplyViewController), animated: true, completion: {() in
                // 回复成功后，刷新当前页面
                // 调用 self.fetch() 不生效，也不知道为啥
//                self.view.makeToast("回复成功") 这个也没效果，只好用block了。。
            })
        } else {
            UIAlertController.showAlert(message: NSLocalizedString("my_login_tip", comment: ""))
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        fetch();
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let msg = JSON(parseJSON: message.body as! String)
        if (msg["type"] == "click_reply") {
            detail_reply_id = msg["reply_id"].rawString()
            detail_reply_loginname = msg["loginname"].rawString()
            replyClick()
        } else if (msg["type"] == "to_user_center") {
            let userCenterViewController = UserCenterViewController()
            userCenterViewController.type = 1
            userCenterViewController.loginname = msg["loginname"].rawString()
            self.navigationController?.pushViewController(userCenterViewController, animated: true)
        } else if (msg["type"] == "click_a") {
            var href = msg["href"].rawString()
//            print(href)
            
            let urlComponents = URLComponents(string: href!)!
//            if let scheme = urlComponents.scheme {
//                print("scheme: \(scheme)")
//            }
//            if let user = urlComponents.user {
//                print("user: \(user)")
//            }
//            if let password = urlComponents.password {
//                print("password: \(password)")
//
//            }
//            if let host = urlComponents.host {
//                print("host: \(host)")
//
//            }
//            if let port = urlComponents.port {
//                print("port: \(port)")
//
//            }
//            print("path: \(urlComponents.path)")
//            if let query = urlComponents.query {
//                print("query: \(query)")
//            }
//            if let queryItems = urlComponents.queryItems {
//                print("queryItems: \(queryItems)")
//                for (index, queryItem) in queryItems.enumerated() {
//                    print("第\(index)个queryItem name:\(queryItem.name)")
//                    if let value = queryItem.value {
//                        print("第\(index)个queryItem value:\(value)")
//                    }
//                }
//            }
            
            if urlComponents.scheme != nil && urlComponents.host != "cnodejs.org" {
                UIApplication.shared.open(URL(string: href!)!, options: [:], completionHandler: nil)
            } else if urlComponents.scheme == nil && urlComponents.path.contains("/user") {
                href = href?.replacingOccurrences(of: "/user/", with: "")
                let userCenterViewController = UserCenterViewController()
                userCenterViewController.type = 1
                userCenterViewController.loginname = href
                self.navigationController?.pushViewController(userCenterViewController, animated: true)
            } else if urlComponents.scheme != nil && urlComponents.host == "cnodejs.org" {
                let _topic_id = urlComponents.path.replacingOccurrences(of: "/topic/", with: "")
                let topicDetailWebViewController = TopicDetailWebViewController()
                topicDetailWebViewController.topic_id = _topic_id
                self.navigationController?.pushViewController(topicDetailWebViewController, animated: true)
            }
        } else if (msg["type"] == "click_img") {
            let img_src = msg["img_src"].rawString()
            let imageBrowser = YBImageBrowser()
            let cellData = YBImageBrowseCellData()
            cellData.url = URL(string: img_src!)
            imageBrowser.dataSourceArray = [cellData]
            imageBrowser.show()
        }
    }
}
