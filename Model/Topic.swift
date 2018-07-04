//
//  Topic.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

struct Topic: Decodable {
    var id: String?
    var author_id: String?
    var tab: String?
    var content: String?
    var title: String?
    var last_reply_at: Date?
    var good: Bool?
    var top: Bool?
    var reply_count: Int?
    var visit_count: Int?
    var create_at: Date?
    var author: Author?
    var is_collect: Bool?
    var replies: [Reply]?
}
