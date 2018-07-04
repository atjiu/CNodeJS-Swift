//
//  LayoutViewController.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/6/30.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit

class LayoutViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = HomeViewController()
        let notificationViewController = NotificationViewController()
        let userViewController = UserViewController()
        
        //修改文字颜色
        //        homeViewController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(CNodeColor.tabColor)], for: .selected)
        //        notificationViewController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(CNodeColor.tabColor)], for: .selected)
        //        userViewController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(CNodeColor.tabColor)], for: .selected)
        
        homeViewController.tabBarItem.title = "话题"
        notificationViewController.tabBarItem.title = "通知"
        userViewController.tabBarItem.title = "我"
        
        homeViewController.tabBarItem.image = UIImage(named: "baseline_home_black_24pt")
        notificationViewController.tabBarItem.image = UIImage(named: "baseline_notifications_black_24pt")
        userViewController.tabBarItem.image = UIImage(named: "baseline_account_circle_black_24pt")
        
        self.viewControllers = [homeViewController, notificationViewController, userViewController]
        // 文字图片颜色一块修改
        self.tabBar.tintColor = UIColor(CNodeColor.tabColor)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
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
