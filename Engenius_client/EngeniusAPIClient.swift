//
//  EngeniusAPIClient.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/01/10.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation

struct EngeniusAPIClient {
    let apiClient: AlamofireClient
    init(apiClient: AlamofireClient) {
        self.apiClient = apiClient
    }

    private func jsonDecode<T:Decodable>(responseType: T.Type, response: @escaping (T) -> ()) -> (Data?) -> () {
        return { responseData in
            guard let data = responseData else {
                return
            }
            do {
                response(try JSONDecoder().decode(responseType.self, from: data))
            } catch {
                print(error)
            }
        }
    }

    func fetchCategory(response: @escaping (Category) -> ()) {
        apiClient.request(urlRequest: EngeniusAPIRouter.category.getCategories(), response: jsonDecode(responseType: Category.self, response: { category in
            response(category)
        }))
    }

    func fetchNewsFeed(categories: [String], page: Int, response: @escaping ([Article]) -> ()) {
        apiClient.request(urlRequest: EngeniusAPIRouter.article.fetchFeed(categories: categories, page: page)) { responseData in
            guard let data = responseData else {
                return
            }
            do {
                response(try JSONDecoder().decode([Article].self, from: data))
            } catch {
                print(error)
            }
        }
    }

    func fetchCategoryArticles(category: String, page: Int, response: @escaping ([Article]) -> ()) {
        apiClient.request(urlRequest: EngeniusAPIRouter.article.fetchArticle(category: category, page: page)) { responseData in
            guard let data = responseData else {
                return
            }
            do {
                response(try JSONDecoder().decode([Article].self, from: data))
            } catch {
                print(error)
            }
        }
    }
}
