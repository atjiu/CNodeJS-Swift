//
//  AppColor.swift
//
//  Created by H on 2018/11/8.
//  Copyright © 2018 H. All rights reserved.
//
//  这个类来自 @Finb 开发的 [V2ex-Swift](https://github.com/Finb/V2ex-Swift) 中的 V2EXColor.swift

import UIKit
import KVOController
import UIColor_Hex_Swift

//使用协议 方便以后切换颜色配置文件、或者做主题配色之类乱七八糟产品经理最爱的功能

protocol AppColorProtocol{
    var titleColor: UIColor {get}
    var cellBackgroundColor: UIColor {get}
    var navigationBackgroundColor: UIColor {get}
    var backgroundColor: UIColor {get}
    var tabColor: UIColor {get}
    var usernameColor: UIColor {get}
    var timeColor: UIColor {get}
    var tabBackgroundColor: UIColor {get}
    var tabStripOldColor: UIColor {get}
}

class DefaultColor: NSObject,AppColorProtocol {
    static let sharedInstance = DefaultColor()
    fileprivate override init(){
        super.init()
    }
    var titleColor: UIColor {
        get {
            return UIColor("#0f0f0f")
        }
    }
    var cellBackgroundColor: UIColor {
        get {
            return UIColor("#fff")
        }
    }
    var navigationBackgroundColor: UIColor {
        get {
            return UIColor("#666")
        }
    }
    var backgroundColor: UIColor {
        get {
            return UIColor("#f2f3f5")
        }
    }
    var tabColor: UIColor {
        get {
            return UIColor("#80bd01")
        }
    }
    var usernameColor: UIColor {
        get {
            return UIColor("#353535")
        }
    }
    var timeColor: UIColor {
        get {
            return UIColor("#778087")
        }
    }
    var tabBackgroundColor: UIColor {
        get {
            return UIColor("#f3f3f3")
        }
    }
    var tabStripOldColor: UIColor {
        get {
            return UIColor("#201f24")
        }
    }
}


/// Dark Colors
class DarkColor: NSObject,AppColorProtocol {
    static let sharedInstance = DarkColor()
    fileprivate override init(){
        super.init()
    }
    var titleColor: UIColor {
        get {
            return UIColor("#919191")
        }
    }
    var cellBackgroundColor: UIColor {
        get {
            return UIColor("#232227")
        }
    }
    var navigationBackgroundColor: UIColor {
        get {
            return UIColor("#A5A5A5")
        }
    }
    var backgroundColor: UIColor {
        get {
            return UIColor("#201f24")
        }
    }
    var tabColor: UIColor {
        get {
            return UIColor("#80bd01")
        }
    }
    var usernameColor: UIColor {
        get {
            return UIColor("#7d7d7d")
        }
    }
    var timeColor: UIColor {
        get {
            return UIColor("#778087")
        }
    }
    var tabBackgroundColor: UIColor {
        get {
            return UIColor("#282828")
        }
    }
    var tabStripOldColor: UIColor {
        get {
            return UIColor("#0f0f0f")
        }
    }
}


class AppColor :NSObject  {
    fileprivate static let STYLE_KEY = "styleKey"
    
    static let AppColorStyleDefault = "Default"
    static let AppColorStyleDark = "Dark"
    
    fileprivate static var _colors:AppColorProtocol?
    static var colors: AppColorProtocol {
        get{
            if let c = AppColor._colors {
                return c
            }
            else{
                if AppColor.sharedInstance.style == AppColor.AppColorStyleDefault{
                    return DefaultColor.sharedInstance
                }
                else{
                    return DarkColor.sharedInstance
                }
            }
        }
        set{
            AppColor._colors = newValue
        }
    }
    
    @objc dynamic var style:String
    static let sharedInstance = AppColor()
    fileprivate override init(){
        if let style = UserDefaults.standard.string(forKey: AppColor.STYLE_KEY) {
            self.style = style
        }
        else{
            self.style = AppColor.AppColorStyleDefault
        }
        super.init()
    }
    func setStyleAndSave(_ style:String){
        if self.style == style {
            return
        }
        
        if style == AppColor.AppColorStyleDefault {
            AppColor.colors = DefaultColor.sharedInstance
        }
        else{
            AppColor.colors = DarkColor.sharedInstance
        }
        
        self.style = style
        UserDefaults.standard.setValue(style, forKey: AppColor.STYLE_KEY)
    }
}

//MARK: - 主题更改时，自动执行
extension NSObject {
    fileprivate struct AssociatedKeys {
        static var themeChanged = "themeChanged"
    }
    
    /// 当前主题更改时、第一次设置时 自动调用的闭包
    public typealias ThemeChangedClosure = @convention(block) (_ style:String) -> Void
    
    /// 自动调用的闭包
    /// 设置时，会设置一个KVO监听，当V2Style.style更改时、第一次赋值时 会自动调用这个闭包
    var themeChangedHandler:ThemeChangedClosure? {
        get {
            let closureObject: AnyObject? = objc_getAssociatedObject(self, &AssociatedKeys.themeChanged) as AnyObject?
            guard closureObject != nil else{
                return nil
            }
            let closure = unsafeBitCast(closureObject, to: ThemeChangedClosure.self)
            return closure
        }
        set{
            guard let value = newValue else{
                return
            }
            let dealObject: AnyObject = unsafeBitCast(value, to: AnyObject.self)
            objc_setAssociatedObject(self, &AssociatedKeys.themeChanged,dealObject,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //设置KVO监听
            self.kvoController.observe(AppColor.sharedInstance, keyPath: "style", options: [.initial,.new] , block: {[weak self] (nav, color, change) -> Void in
                self?.themeChangedHandler?(AppColor.sharedInstance.style)
                }
            )
        }
    }
}

