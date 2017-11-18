//
//  Engenius_clientTests.swift
//  Engenius_clientTests
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import XCTest
@testable import Engenius_client

class Engenius_clientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCategoryModel() {
        let payload: Data = try! JSONEncoder().encode(["categories":["a", "b", "c", "d"]])

        let category = try! JSONDecoder().decode(Category.self, from: payload)
        XCTAssert(category.categories == ["a", "b", "c", "d"])
    }

    func testArticleMode() {
        var payload: Data = try! JSONEncoder().encode([
            "title": "article-title",
            "link": "http://example.com",
            "post_date": "1996-05-19",
            "image_url": "http://example/image.jpg",
            "category": "Swift"
            ])

        var article = try! JSONDecoder().decode(Article.self, from: payload)
        XCTAssert(article.title == "article-title")
        XCTAssert(article.url == URL(string: "http://example.com"))
        XCTAssert(article.postDate == "1996-05-19")
        XCTAssert(article.imageURL == URL(string: "http://example/image.jpg"))
        XCTAssert(article.category == "Swift")

        payload = try! JSONEncoder().encode([
            "title": "article-title",
            "link": "http://example.com",
            "post_date": "1996-05-19",
            "image_url": nil,
            "category": "Swift"
            ])
        article = try! JSONDecoder().decode(Article.self, from: payload)
        XCTAssertNil(article.imageURL)
    }

    func testArticles() {
        let payload: Data = try! JSONEncoder().encode([
                [
                    "title": "article-title",
                    "link": "http://example.com",
                    "post_date": "1996-05-19",
                    "image_url": "http://example/image.jpg",
                    "category": "Swift"
                ],
                [
                    "title": "article-title",
                    "link": "http://example.com",
                    "post_date": "1996-05-19",
                    "image_url": nil,
                    "category": "Swift"
                ]
            ])
        let articles:[Article] = try! JSONDecoder().decode([Article].self, from: payload)
        XCTAssert(articles[0].title == "article-title")
        XCTAssert(articles[0].title == "article-title")
        XCTAssert(articles[0].url == URL(string: "http://example.com"))
        XCTAssert(articles[0].postDate == "1996-05-19")
        XCTAssert(articles[0].imageURL == URL(string: "http://example/image.jpg"))
        XCTAssert(articles[0].category == "Swift")
        XCTAssertNil(articles[1].imageURL)
    }

    func testCategoryURLRoute() {
        let request = URLRequest(url: URL(string: "http://engeniusalb-2015328251.ap-northeast-1.elb.amazonaws.com/category.json")!)
        XCTAssertEqual(try! EngeniusAPIRouter.category.getCategories().asURLRequest(), request)
    }

    func testArticleURLRoute() {
        let baseURL = "http://engeniusalb-2015328251.ap-northeast-1.elb.amazonaws.com/article"

        var request = URLRequest(url: URL(string: baseURL + ".json?limit=7")!)
        XCTAssertEqual(try! EngeniusAPIRouter.article.fetchFeed(limit: 7, page: 0).asURLRequest(), request)

        request = URLRequest(url: URL(string: baseURL + ".json?limit=7&offset=7")!)
        XCTAssertEqual(try! EngeniusAPIRouter.article.fetchFeed(limit: 7, page: 1).asURLRequest(),
                       request)

        request = URLRequest(url: URL(string: baseURL + "/show.json?category=Swift&limit=7")!)
        XCTAssertEqual(try! EngeniusAPIRouter.article.fetchArticle(category: "Swift", limit: 7, page: 0).asURLRequest(), request)

        request = URLRequest(url: URL(string: baseURL + "/show.json?category=Swift&limit=7&offset=7")!)
        XCTAssertEqual(try! EngeniusAPIRouter.article.fetchArticle(category: "Swift", limit: 7, page: 1).asURLRequest(), request)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
