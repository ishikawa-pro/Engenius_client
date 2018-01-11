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
    private static var baseURL: URL {
        return URL(string: "http://192.168.100.101:3000")!
    }

    enum category : URLRequestConvertible {
        case getCategories()

        var path: String {
            switch self {
            case .getCategories:
                return "/category.json"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let urlRequest = URLRequest(url: EngeniusAPIRouter.baseURL.appendingPathComponent(path))
            return try URLEncoding.default.encode(urlRequest, with: nil)
        }
    }

    enum article : URLRequestConvertible {
        case fetchFeed(categories: [String],page: Int)
        case fetchArticle(category: String, page: Int)

        var path: String {
            switch self {
            case .fetchFeed:
                return "/article.json"
            case .fetchArticle:
                return "/article/show.json"
            }
        }

        static let offset = 15
        static let limit = 15

        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                case let .fetchFeed(categories, page) where page > 0:
                    return ("/article.json", ["category": categories, "limit": article.limit, "offset": page * article.offset])
                case let .fetchFeed(categories, _):
                    return ("/article.json", ["category": categories, "limit": article.limit])
                case let .fetchArticle(category, page) where page > 0:
                    return ("/article/show.json", ["category": category, "limit": article.limit, "offset": page * article.offset])
                case let .fetchArticle(category, _):
                    return ("/article/show.json", ["category": category, "limit": article.limit])
                }
            }()

            let urlRequest = URLRequest(url: EngeniusAPIRouter.baseURL.appendingPathComponent(result.path))
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
