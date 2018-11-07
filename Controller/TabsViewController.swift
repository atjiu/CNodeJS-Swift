//
//  ViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UIColor_Hex_Swift
import NightNight

class TabsViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        self.settings.style.buttonBarBackgroundColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
        self.settings.style.buttonBarItemBackgroundColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        self.settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        self.settings.style.buttonBarItemTitleColor = UIColor(CNodeColor.tabColor)
        self.settings.style.buttonBarHeight = 35
        //
//        settings.style.buttonBarMinimumLineSpacing = 0
//        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        //
        // 根据主题换色
        if NightNight.theme == .normal {
            self.settings.style.buttonBarBackgroundColor = UIColor(CNodeColor.backgroundColor)
            self.settings.style.buttonBarItemBackgroundColor = UIColor(CNodeColor.backgroundColor)
        } else {
            self.settings.style.buttonBarBackgroundColor = UIColor(CNodeColor.backgroundColor_dark)
            self.settings.style.buttonBarItemBackgroundColor = UIColor(CNodeColor.backgroundColor_dark)
        }
        
        self.settings.style.selectedBarHeight = 2
        self.settings.style.selectedBarBackgroundColor = UIColor(CNodeColor.tabColor)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.mixedTextColor = MixedColor(normal: UIColor(CNodeColor.backgroundColor_dark), night: UIColor(CNodeColor.backgroundColor))
            newCell?.label.textColor = UIColor(CNodeColor.tabColor)
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
        
        super.viewDidLoad()
    }
    
    var setBadge: ((_ count: Int) -> Void)?
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let tabs = [
            (NSLocalizedString("tab_all", comment: ""), ""),
            (NSLocalizedString("tab_good", comment: ""), "good"),
            (NSLocalizedString("tab_ask", comment: ""), "ask"),
            (NSLocalizedString("tab_share", comment: ""), "share"),
//            ("博客", "blog"), // 接口中没有提供这个tab
            (NSLocalizedString("tab_job", comment: ""), "job"),
//            ("调试", "dev")
        ]
        var uiViewControllers = [TabTopicViewController]()
        for tab in tabs {
            let tabTopicViewController = TabTopicViewController()
            tabTopicViewController.tabText = tab.0
            tabTopicViewController.tab = tab.1
            uiViewControllers.append(tabTopicViewController)
            
            tabTopicViewController.setBadge = {[weak self] count in
                self?.setBadge?(count)
            }
        }
        return uiViewControllers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

