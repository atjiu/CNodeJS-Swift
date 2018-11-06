//
//  HomeViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let tabsViewController = TabsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = NSLocalizedString("tablayout_topic", comment: "")
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        self.addChildViewController(tabsViewController)
        self.view.addSubview(tabsViewController.view)
        
        tabsViewController.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NavigationBarHeight)
            make.left.right.bottom.equalTo(0)
        }
        
        tabsViewController.setBadge = { [weak self] count in
            self?.setBadge?(count)
        }
    }
    
    var setBadge: ((_ count: Int) -> Void)?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
