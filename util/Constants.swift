//
//  Constants.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import DeviceKit

//屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
//屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
//NavagationBar高度
let NavigationBarHeight:CGFloat = {
    let device = Device()
    if device.isOneOf([.iPhoneX, Device.simulator(.iPhoneX)]) {
        return 88
    }
    return 64
}()

class CNodeColor {
    static let tabColor = "#80bd01"
    static let timeColor = "#5d5d5d"
}
