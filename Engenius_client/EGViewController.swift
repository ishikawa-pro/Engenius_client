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
    var categories:[String]? {
        didSet {
            var articleViewController: ArticlesTableViewController

            guard let categories = categories else {
                return
            }
            //カテゴリごとの記事一覧を作成
            for category in categories {
                articleViewController = ArticlesTableViewController()
                articleViewController.title = category
                articleViewController.delegate = self
                articleViewControllers.append(articleViewController)
            }
            _ = viewControllers(for: self)
            reloadPagerTabStripView()
        }
    }
    
    // インスタンス配列
    var articleViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()

        let interestedCategories = realm.objects(InterestedCategory.self)
        categories = interestedCategories.flatMap{$0.category}

        //cateogryの取得
        Alamofire.request(EngeniusAPIRouter.category.getCategories()).responseData { (response) in
            guard let data = response.data else {
                return
            }
            do {
                self.categories = try JSONDecoder().decode(Category.self, from: data).categories
            } catch {
                print("error")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if (articleViewControllers.count == 0) {
            let newsFeedViewController = ArticlesTableViewController()
            newsFeedViewController.delegate = self
            newsFeedViewController.title = "最新記事"
            articleViewControllers.append(newsFeedViewController)
            return articleViewControllers
        } else {
            return articleViewControllers
        }
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

