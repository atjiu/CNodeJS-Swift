//
//  Notification.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/8/14.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

struct Notification: Decodable {
    var has_read_messages: [Message]
    var hasnot_read_messages: [Message]
}
