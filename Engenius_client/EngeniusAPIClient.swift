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
    func fetchCategory(response: @escaping (Category) -> ()) {
        apiClient.request(urlRequest: EngeniusAPIRouter.category.getCategories()) { data in
            do {
                response(try JSONDecoder().decode(Category.self, from: data))
            } catch {
                print(error)
            }

        }
    }

    func fetchNewsFeed(categories: [String], page: Int, response: @escaping ([Article]) -> ()) {
        apiClient.request(urlRequest: EngeniusAPIRouter.article.fetchFeed(categories: categories, page: page)) { data in
            do {
                response(try JSONDecoder().decode([Article].self, from: data))
            } catch {
                print(error)
            }
        }
    }

    func fetchCategoryArticles(category: String, page: Int, response: @escaping ([Article]) -> ()) {
        apiClient.request(urlRequest: EngeniusAPIRouter.article.fetchArticle(category: category, page: page)) { data in
            do {
                response(try JSONDecoder().decode([Article].self, from: data))
            } catch {
                print(error)
            }
        }
    }
}
