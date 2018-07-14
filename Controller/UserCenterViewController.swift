//
//  UserCenterViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/11.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit

class UserCenterViewController: UIViewController {
    
    var loginname: String!
    
    let tabsTopicAndReplyViewController = TabsTopicAndReplyViewController()
    let header = UserHeaderTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loginname
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        self.view.addSubview(header)
        self.addChildViewController(tabsTopicAndReplyViewController)
        self.view.addSubview(tabsTopicAndReplyViewController.view)
        
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.left.right.equalTo(0)
        }
        
        tabsTopicAndReplyViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.header.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
