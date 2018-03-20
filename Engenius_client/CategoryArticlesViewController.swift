//
//  ArticlesTableViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/31.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CategoryArticlesViewController: ArticlesViewController  {
    var notificationCenter: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView?.refreshControl = UIRefreshControl()
        articleTableView?.refreshControl?.addTarget(self, action: #selector(type(of: self).fetchArticles), for:  UIControlEvents.valueChanged)
        notificationCenter = NotificationCenter.default
        notificationCenter?.addObserver(self, selector: #selector(type(of: self).fetchArticles), name: .fetchArticles, object: nil)
        fetchArticles()
    }

}

extension CategoryArticlesViewController : ArticlesViewControllerType {
    //NewsFeedView固有の関数
    func fetchArticles() {
        guard let category = indicatorTitle else {
            return
        }
        engeniusAPIClient.fetchNewsFeed(categories: [category], page: page, response: response)        
    }
}
