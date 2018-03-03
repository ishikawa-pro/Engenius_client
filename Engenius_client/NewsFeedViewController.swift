//
//  NewsFeedViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/01/12.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class NewsFeedViewController: ArticlesViewController, ArticlesViewControllerType {
    var notificationCenter: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter = NotificationCenter.default
        notificationCenter?.addObserver(self, selector: #selector(type(of: self).fetchArticles), name: .fetchArticles, object: nil)
        getSelectedCategory()
        fetchArticles()
    }
    //NewsFeedView固有の関数
    func getSelectedCategory() {
        do {
            let realm = try Realm()
            selectedCategory = realm.objects(InterestedCategory.self).map { $0.category }
        }
        catch {
            print(error)
        }
    }
    
    //NewsFeedView固有の関数
    func fetchArticles() {
        engeniusAPIClient.fetchNewsFeed(categories: selectedCategory, page: page, response: response)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

