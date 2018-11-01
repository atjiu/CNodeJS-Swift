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

class TabsViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        self.settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        self.settings.style.buttonBarItemTitleColor = UIColor(CNodeColor.tabColor)
        self.settings.style.buttonBarHeight = 40
        self.settings.style.buttonBarBackgroundColor = .white
        self.settings.style.buttonBarItemBackgroundColor = .white
        self.settings.style.selectedBarHeight = 2
        self.settings.style.selectedBarBackgroundColor = UIColor(CNodeColor.tabColor)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .black
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let tabs = [
            ("全部", ""),
            ("精华", "good"),
            ("分享", "share"),
            ("问答", "ask"),
            ("招聘", "job"),
            ("调试", "dev")
        ]
        var uiViewControllers = [TabTopicViewController]()
        for tab in tabs {
            let tabTopicViewController = TabTopicViewController()
            tabTopicViewController.tabText = tab.0
            tabTopicViewController.tab = tab.1
            uiViewControllers.append(tabTopicViewController)
        }
        return uiViewControllers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

