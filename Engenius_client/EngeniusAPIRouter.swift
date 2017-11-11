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
    static let baseURLString = "http://engeniusalb-2015328251.ap-northeast-1.elb.amazonaws.com"

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

    enum article : URLRequestConvertible {
        case getFeed(limit: Int, page: Int)
        case getArticle(category: String, limit: Int, page: Int)

        var path: String {
            switch self {
            case .getFeed:
                return "/article.json"
            case .getArticle:
                return "/article/show.json"
            }
        }

        static let offset = 7

        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                case let .getFeed(limit, page) where page > 0:
                    return ("/article.json", ["limit": limit, "offset": page * article.offset])
                case let .getFeed(limit, _):
                    return ("/article.json", ["limit": limit])
                case let .getArticle(category, limit, page) where page > 0:
                    return ("/article/show.json", ["category": category, "limit": limit, "offset": page * article.offset])
                case let .getArticle(category, limit, _):
                    return ("/article/show.json", ["category": category, "limit": limit])
                }
            }()

            let url = try EngeniusAPIRouter.baseURLString.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
