//
//  Constants.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import DeviceKit

let BASE_URL = "https://cnodejs.org"
//回复小尾巴
let REPLY_TAIL = "\n\n来自实用的 [CNodeJS-Swift](https://github.com/tomoya92/CNodeJS-Swift)"
//屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
//屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
//NavagationBar高度
let NavigationBarHeight:CGFloat = {
    if UIDevice.current.isIphoneX {
        return 88
    }
    return 64
}()
// viewport
let VIEWPORT = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,user-scalable=no,minimal-ui\">"
let CSS = try! String(contentsOfFile: Bundle.main.path(forResource: "app", ofType: "css")!, encoding: String.Encoding.utf8)
let JS = try! String(contentsOfFile: Bundle.main.path(forResource: "underscore.min", ofType: "js")!, encoding: String.Encoding.utf8)
let TOPICDETAILHTML = try! String(contentsOfFile: Bundle.main.path(forResource: "topic_detail", ofType: "html")!, encoding: String.Encoding.utf8)

extension UIDevice {
    var isIphoneX:Bool {
        get {
            let device = Device()
            if device.isOneOf([
                Device.iPhoneX,
                Device.simulator(.iPhoneX),
                .iPhoneXs,
                Device.simulator(.iPhoneXs),
                .iPhoneXr,
                Device.simulator(.iPhoneXr),
                .iPhoneXsMax,
                Device.simulator(.iPhoneXsMax)]) {
                return true
            }
            return false
        }
    }
}

class CNodeColor {
    static let tabColor = "#80bd01"
    static let timeColor = "#5d5d5d"
    static let grayColor = "#f5f5f5"
    static let tableViewHeaderColor = "#f7f7f7"
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
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return "\(year) \(NSLocalizedString("time_year", comment: ""))"
        } else if let month = interval.month, month > 0 {
            let day = interval.day!
            return day < 15 ? "\(month) \(NSLocalizedString("time_month", comment: ""))" : "\(month + 1) \(NSLocalizedString("time_month", comment: ""))"
        } else if let day = interval.day, day > 0 {
            let hour = interval.hour!
            return hour < 12 ? "\(day) \(NSLocalizedString("time_day", comment: ""))" : "\(day + 1) \(NSLocalizedString("time_day", comment: ""))"
        } else if let hour = interval.hour, hour > 0 {
            let minute = interval.minute!
            return minute < 30 ? "\(hour) \(NSLocalizedString("time_hour", comment: ""))" : "\(hour + 1) \(NSLocalizedString("time_hour", comment: ""))"
        } else if let minute = interval.minute, minute > 0 {
            let second = interval.second!
            return second < 30 ? "\(minute) \(NSLocalizedString("time_minute", comment: ""))" : "\(minute + 1) \(NSLocalizedString("time_minute", comment: ""))"
        } else {
            return "\(interval.second!)" + " \(NSLocalizedString("time_second", comment: ""))"
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert_confirm", comment: ""), style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出普通消息提示框
    static func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
    
    //在指定视图控制器上弹出确认框
    static func showConfirm(message: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert_confirm", comment: ""), style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出确认框
    static func showConfirm(message: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: vc, confirm: confirm)
        }
    }
}
