//
//  Result.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

struct Result<T: Decodable>: Decodable {
    var success: Bool?
    var data: T?
}
