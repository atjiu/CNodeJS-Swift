//
//  SwiftJavaScriptModel.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/4.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    func callHandler(handleFuncName: String) {
//        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("\(handleFuncName)")
//        let dict = ["name": "sean", "age": 18]
//        jsHandlerFunc?.callWithArguments([dict])
        print(handleFuncName)
    }
}
