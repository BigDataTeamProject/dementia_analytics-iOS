//
//  APIService.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/03.
//

import Foundation
import Moya

enum APIService {
    case predict(Data)
}

extension APIService: TargetType {
    var baseURL: URL {
        switch self {
        case .predict:
            return URL(string: "http://127.0.0.1:5000")!
        }
    }
    
    var path: String {
        switch self {
        case .predict:
            return "predict"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .predict:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .predict(data): return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

