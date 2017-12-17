//
//  ViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SafariServices
import Alamofire
import RealmSwift


class EGViewController: ButtonBarPagerTabStripViewController, articlesTableViewDelegate{
    var categories:[String] = ["最新記事"] {
        didSet {
            _ = viewControllers(for: self)
            reloadPagerTabStripView()
        }
    }
    
    // インスタンス配列
    var articleViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            let realm = try Realm()
            var selectedCategory:[String] = realm.objects(InterestedCategory.self).map { $0.category }
            selectedCategory.insert("最新記事", at: 0)
            categories = selectedCategory
        }
        catch (let e) {
            print(e)
        }
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //カテゴリごとの記事一覧を作成
        articleViewControllers = categories.map { (category) -> ArticlesTableViewController in
            let articleViewController = ArticlesTableViewController()
            articleViewController.title = category
            articleViewController.delegate = self
            return articleViewController
        }
        return articleViewControllers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func configButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Config", bundle: nil)
        guard let ConfigViewController = storyboard.instantiateViewController(withIdentifier: "ConfigViewController")as? UITableViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: ConfigViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    //ArticlesTableViewControllerからのデリゲート
    //セルをタップすると呼ばれる
    func showArticle(url: URL?) {
        guard let url = url else {
            return
        }
        let nextVC = SFSafariViewController(url: url)
        navigationController?.present(nextVC, animated: true, completion: nil)
    }
}

