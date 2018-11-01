//
//  LayoutViewController.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/6/30.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit

class LayoutViewController: UITabBarController {
    
    let homeViewController = HomeViewController()
    let notificationViewController = NotificationViewController()
    let userViewController = UserViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // 添加角标
//        notificationViewController.tabBarItem.badgeValue = "10"
//        notificationViewController.tabBarItem.badgeColor = UIColor.red
        // 清除角标
//        notificationViewController.tabBarItem.badgeValue = nil
        
        self.viewControllers = [homeViewController, notificationViewController, userViewController]
        // 文字图片颜色一块修改
        self.tabBar.tintColor = UIColor(CNodeColor.tabColor)
        
        homeViewController.setBadge = {[weak self] count in
            if count == 0 {
                self?.notificationViewController.tabBarItem.badgeValue = nil
            } else {
                self?.notificationViewController.tabBarItem.badgeValue = "\(count)"
                self?.notificationViewController.tabBarItem.badgeColor = UIColor.red
            }
        }
        notificationViewController.setBadge = {[weak self] count in
            if count == 0 {
                self?.notificationViewController.tabBarItem.badgeValue = nil
            } else {
                self?.notificationViewController.tabBarItem.badgeValue = "\(count)"
                self?.notificationViewController.tabBarItem.badgeColor = UIColor.red
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
//        if item.title == "通知" || item.title == "我" {
//            if !isLogin {
//                let alert = UIAlertController(title: "请先登录", message: "您要打开的页面需要登录才能访问，是否去扫码登录？", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "去扫码", style: .default, handler: { (action: UIAlertAction!) in
//                    print("Handle Ok logic here")
//                }))
//                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
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
