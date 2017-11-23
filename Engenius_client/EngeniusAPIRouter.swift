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
        case fetchFeed(page: Int)
        case fetchArticle(category: String, page: Int)

        var path: String {
            switch self {
            case .fetchFeed:
                return "/article.json"
            case .fetchArticle:
                return "/article/show.json"
            }
        }

        static let offset = 10
        static let limit = 10

        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                case let .fetchFeed(page) where page > 0:
                    return ("/article.json", ["limit": article.limit, "offset": page * article.offset])
                case .fetchFeed(_):
                    return ("/article.json", ["limit": article.limit])
                case let .fetchArticle(category, page) where page > 0:
                    return ("/article/show.json", ["category": category, "limit": article.limit, "offset": page * article.offset])
                case let .fetchArticle(category, _):
                    return ("/article/show.json", ["category": category, "limit": article.limit])
                }
            }()

            let url = try EngeniusAPIRouter.baseURLString.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
