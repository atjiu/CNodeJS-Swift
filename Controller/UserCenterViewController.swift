//
//  UserCenterViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/11.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import NightNight

class UserCenterViewController: UIViewController {
    
    let provider = MoyaProvider<CNodeService>()
    var type: Int!
    var loginname: String!
    let tabsTopicAndReplyViewController = TabsTopicAndReplyViewController()
    let header = UserHeaderTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loginname
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor(CNodeColor.backgroundColor), night: UIColor(CNodeColor.backgroundColor_dark))
        self.navigationController?.navigationBar.mixedBarTintColor = MixedColor(normal: UIColor(CNodeColor.navigationBackgroundColor), night: UIColor(CNodeColor.navigationBackgroundColor_dark))
        // 设置返回颜色
        self.navigationController?.navigationBar.mixedTintColor = MixedColor(normal: UIColor(CNodeColor.navigationBackgroundColor_dark), night: UIColor(CNodeColor.navigationBackgroundColor))
        
        self.view.addSubview(header)
        self.addChildViewController(tabsTopicAndReplyViewController)
        self.view.addSubview(tabsTopicAndReplyViewController.view)
        
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NavigationBarHeight)
            make.left.right.equalTo(0)
        }
        
        tabsTopicAndReplyViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.header.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        
        self.view.makeToastActivity(.center)
        
        // 请求用户信息
        provider.request(.user(loginname: loginname)) { (res) in
            switch res {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let result = try! decoder.decode(Result<Author>.self, from: response.data)
//                self.topicsVC.reloadData((result.data?.recent_topics)!)
//                self.repliesVC.reloadData((result.data?.recent_replies)!)
                // 传参
                self.header.type = self.type
                self.header.author = result.data!
                self.header.bind()
                self.tabsTopicAndReplyViewController.reloadData(topics: (result.data?.recent_topics)!, replies: (result.data?.recent_replies)!)
                self.view.hideToastActivity()
            case .failure(let error):
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
