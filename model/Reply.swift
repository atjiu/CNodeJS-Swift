//
//  TopicDetail.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/2.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

struct Reply: Decodable {
    var id: String?
    var author: Author?
    var content: String?
    var ups: [String]?
    var create_at: Date?
    var reply_id: String?
    var is_uped: Bool?
}
