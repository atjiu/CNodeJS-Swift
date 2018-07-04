//
//  SwiftJavaScriptDelegate.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/4.
//  Copyright © 2018年 H. All rights reserved.
//

import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    func callHandler(handleFuncName: String)
    
}
