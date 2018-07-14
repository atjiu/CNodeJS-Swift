//
//  CNodeService.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/6/29.
//  Copyright © 2018年 H. All rights reserved.
//

import Foundation
import Moya

enum CNodeService {
    case topics(page: Int, tab: String)
    case topicDetail(id: String)
    case accessToken(token: String)
    case user(loginname: String)
    case collect(loginname: String, page: Int)
}

extension CNodeService: TargetType {
    var baseURL: URL {
        return URL(string: "\(BASE_URL)/api/v1")!
    }
    
    var path: String {
        switch self {
        case .topics:
            return "/topics"
        case .topicDetail(let id):
            return "/topic/\(id)"
        case .accessToken:
            return "/accesstoken"
        case .user(let loginname):
            return "/user/\(loginname)"
        case .collect(let loginname, _):
            return "/topic_collect/\(loginname)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .topics, .topicDetail, .user, .collect:
            return .get
        case .accessToken:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .topics(let page, let tab):
            return .requestParameters(parameters: ["page": page, "tab": tab, "limit": 50], encoding: URLEncoding.default)
        case .topicDetail:
            return .requestPlain
        case .accessToken(let token):
            return .requestParameters(parameters: ["accesstoken": token], encoding: URLEncoding.default)
        case .user:
            return .requestPlain
        case .collect(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}

