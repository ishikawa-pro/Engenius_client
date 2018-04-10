//
//  ArticlesViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/12/27.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import XLPagerTabStrip

protocol ArticlesViewControllerDelegate {
    func showArticle(url: URL?)
}

protocol ArticlesViewControllerType {
    var notificationCenter: NotificationCenter? {get set}
    var response: (([Article]) -> ()) {get}    
    func fetchArticles()    
}

// MARK: ArticlesTableViewController

extension IndicatorInfoProvider where Self: ArticlesTableViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: indicatorTitle)
    }
}

extension ArticlesViewControllerType where Self: ArticlesTableViewController {
    var response: (([Article]) -> ()) {
        get {
            return {response in
                //記事がなければappendせずにreturn
                if response.count == 0 {
                    //tableの終端でisFetchingをtrueにすることで新しい記事を取りに行けなくする。
                    self.isFetching = true
                } else {
                    self.articles.append(contentsOf: response)
                    self.page += 1
                }
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}
