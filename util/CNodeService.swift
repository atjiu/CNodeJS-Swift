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
}

extension CNodeService: TargetType {
    var baseURL: URL {
        return URL(string: "https://cnodejs.org/api/v1")!
    }
    
    var path: String {
        switch self {
        case .topics:
            return "/topics"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .topics:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .topics(let page, let tab):
            return .requestParameters(parameters: ["page": page, "tab": tab, "limit": 50], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}

