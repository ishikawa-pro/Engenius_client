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

class NewsFeedTableViewController: ArticlesTableViewController {
    var notificationCenter: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(type(of: self).fetchArticles), for:  UIControlEvents.valueChanged)
        notificationCenter = NotificationCenter.default
        notificationCenter?.addObserver(self, selector: #selector(type(of: self).fetchArticles), name: .fetchArticles, object: nil)
        fetchArticles()
    }

}

extension NewsFeedTableViewController : ArticlesViewControllerType {
    //NewsFeedView固有の関数
    func fetchArticles() {
        engeniusAPIClient.fetchNewsFeed(categories: selectedCategory, page: page, response: response)
    }

    var selectedCategory: [String] {
        get {
            let category: [String]
            do {
                let realm = try Realm()

                category = realm.objects(InterestedCategory.self).map { $0.category }
            }
            catch {
                print(error)
                category = [""]
            }
            return category
        }
    }
}
