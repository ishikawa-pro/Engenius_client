//
//  ArticlesViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/02/20.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class ArticlesViewController: UIViewController, IndicatorInfoProvider, ArticlesViewControllerType {
    var indicatorTitle: String?

    var delegate: ArticlesViewControllerDelegate?

    func fetchArticles() {

    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
