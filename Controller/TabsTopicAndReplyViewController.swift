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

class TabsTopicAndReplyViewController: ButtonBarPagerTabStripViewController {
    
    var author: Author!
    let topicsVC = TopicOrReplyTableViewController()
    let repliesVC = TopicOrReplyTableViewController()
    
    override func viewDidLoad() {
        self.settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        self.settings.style.buttonBarItemTitleColor = UIColor(CNodeColor.tabColor)
        self.settings.style.buttonBarHeight = 35
        
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
    
    func reloadData(topics: [Topic], replies: [Topic]) {
        self.topicsVC.reloadData(topics)
        self.repliesVC.reloadData(replies)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        topicsVC.tabTitle = NSLocalizedString("tablayout_topic", comment: "")
        repliesVC.tabTitle = NSLocalizedString("topic_reply", comment: "")
        
        return [topicsVC, repliesVC]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

