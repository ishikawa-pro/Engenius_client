//
//  ArticlesTableViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/31.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CategoryArticlesViewController: ArticlesViewController, ArticlesViewControllerType {
    var notificationCenter: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter = NotificationCenter.default
        notificationCenter?.addObserver(self, selector: #selector(type(of: self).fetchArticles), name: .fetchArticles, object: nil)
        fetchArticles()
    }
    
    func fetchArticles() {
        guard let category = indicatorTitle else {
            return
        }
        engeniusAPIClient.fetchCategoryArticles(category: category, page: page,response: response)
    }
}
