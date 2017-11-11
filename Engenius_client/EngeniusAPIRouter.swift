//
//  EngeniusAPIRouter.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/11/10.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import Alamofire

enum EngeniusAPIRouter {
    static let baseURLString = "engeniusalb-2015328251.ap-northeast-1.elb.amazonaws.com"

    enum category : URLRequestConvertible {
        case getCategories()

        var path: String {
            switch self {
            case .getCategories:
                return "/category.json"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let url = try EngeniusAPIRouter.baseURLString.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(path))
            return try URLEncoding.default.encode(urlRequest, with: nil)
        }
    }
}
