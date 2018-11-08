//
//  SwitchButtonTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/11/7.
//  Copyright © 2018 H. All rights reserved.
//

import UIKit

class SwitchButtonTableViewCell: UITableViewCell {
    
    var icon: UIImageView = {
        var icon = UIImageView(image: UIImage(named: "baseline_brightness_2_black_24pt"))
        return icon
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("settings_theme", comment: "")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        var _switch = UISwitch()
        _switch.isOn = AppColor.sharedInstance.style == AppColor.AppColorStyleDark
        _switch.addTarget(self, action: #selector(switchButtonClick), for: .valueChanged)
        return _switch
    }()
    
    // 装上面定义的那些元素的容器
    var contentPanel = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.contentView.addSubview(self.contentPanel)
        
        self.contentPanel.addSubview(icon)
        self.contentPanel.addSubview(titleLabel)
        self.contentPanel.addSubview(switchButton)
        
        contentPanel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-1)
            make.height.equalTo(45)
        }
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentPanel)
            make.left.equalTo(self.contentPanel).offset(18)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon.snp.right).offset(18)
            make.centerY.equalTo(self.icon)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentPanel)
            make.right.equalTo(self.contentPanel).offset(-18)
        }
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.titleLabel.textColor = AppColor.colors.titleColor
            self?.icon.tintColor = AppColor.colors.titleColor
            self?.contentPanel.backgroundColor = AppColor.colors.cellBackgroundColor
            self?.backgroundColor = AppColor.colors.backgroundColor
            selectedBackgroundView.backgroundColor = AppColor.colors.backgroundColor
        }
    }
    
    var switchClick: (() -> Void)?
    
    @objc func switchButtonClick() {
        self.switchClick?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
