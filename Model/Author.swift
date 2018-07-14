//
//  Author.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation

struct Author: Decodable {
    var success: Bool?
    var loginname: String?
    var id: String?
    var avatar_url: String?
    var error_Msg: String?
    var score: Int?
    var create_at: String?
    var githubUsername: String?
    
    var recent_topics: [Topic]?
    var recent_replies: [Topic]?
}
