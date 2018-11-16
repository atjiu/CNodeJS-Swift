//
//  RefreshView.swift
//  CNodeJS-Swift
//
//  Created by h on 2018/7/3.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import MJRefresh

class RefreshView: MJRefreshHeader {
    
    // 转圈的菊花
    var loadingView: UIActivityIndicatorView?
    // 下拉的icon
    var arrowImage = UIImageView()
    
    // 处理不同刷新状态下的组件状态
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                self.loadingView?.isHidden = true
                self.arrowImage.isHidden = false
                self.loadingView?.stopAnimating()
            case .pulling:
                self.loadingView?.isHidden = false
                self.arrowImage.isHidden = true
                self.loadingView?.startAnimating()
            case .refreshing:
                self.loadingView?.isHidden = false
                self.arrowImage.isHidden = true
                self.loadingView?.startAnimating()
            default:
                print("")
            }
        }
    }
    
    // 初始化组件
    override func prepare() {
        super.prepare()
        self.mj_h = 50
        
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        self.addSubview(loadingView!)
        self.addSubview(arrowImage)
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            if style == AppColor.AppColorStyleDefault {
                self?.loadingView?.activityIndicatorViewStyle = .gray
                self?.arrowImage.image = UIImage(named: "baseline_arrow_downward_black_24pt")
            } else {
                self?.loadingView?.activityIndicatorViewStyle = .white
                self?.arrowImage.image = UIImage(named: "baseline_arrow_downward_white_24pt")
            }
            self?.arrowImage.tintColor = AppColor.colors.titleColor
        }
        
    }
    
    // 组件定位
    override func placeSubviews() {
        super.placeSubviews()
        self.loadingView?.center = CGPoint(x: self.mj_w / 2, y: self.mj_h / 2)
        self.arrowImage.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        self.arrowImage.center = self.loadingView!.center
    }
    
}
