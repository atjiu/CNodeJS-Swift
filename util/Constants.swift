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
    static let grayColor = "#f5f5f5"
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date {
    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "年前　　" :
                "\(year)" + " " + "年前"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "月前" :
                "\(month)" + " " + "月前"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "天前" :
                "\(day)" + " " + "天前"
        } else {
            return "几秒前"
        }
    }
}
