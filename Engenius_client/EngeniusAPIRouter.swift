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
        #if LOCAL_SERVER
            return URL(string: "http://192.168.22.186:3000")!
        #else
            return URL(string: "https://murmuring-journey-70649.herokuapp.com")!
        #endif

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

        static var offset: Int {
            return 15
        }
        static var limit: Int {
            return 15
        }

        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                case let .fetchFeed(categories, page):
                    return ("/article.json", ["category": categories, "limit": article.limit, "offset": page * article.offset])                
                case let .fetchArticle(category, page):
                    return ("/article/show.json", ["category": category, "limit": article.limit, "offset": page * article.offset])
                }
            }()

            let urlRequest = URLRequest(url: EngeniusAPIRouter.baseURL.appendingPathComponent(result.path))
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
