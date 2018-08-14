//
//  Message.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/8/14.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

struct Message: Decodable {
    var id: String
    var type: String
    var has_read: Bool
    var author: Author
    var topic: Topic
    var reply: Reply
}
