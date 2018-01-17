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


class EGViewController: ButtonBarPagerTabStripViewController, ArticlesViewControllerDelegate{
    var categories:[String] = ["最新記事"] {
        didSet {
            createArticlesViewControllers()
            _ = viewControllers(for: self)
            reloadPagerTabStripView()
        }
    }
    
    // インスタンス配列
    var articleVCDictionary = [String: ArticlesViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //カテゴリの取得などは、viewDidApperでやらないと描画されるタイミング的にCellがうまく描画されない。
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

    private func createArticlesViewControllers() {
        articleViewControllers = categories.map { (category) -> UIViewController in
            //既に作られているカテゴリのViewControllerなら再利用する。
            //ToDo : リファクタリング
            if let newsFeedViewController = articleViewControllers
                .filter({ _ in category == "最新記事" })
                .first {
                return newsFeedViewController
            } else if articleViewControllers.count == 0 {
                let newsFeedViewController = NewsFeedViewController()
                newsFeedViewController.title = category
                newsFeedViewController.delegate = self
                return newsFeedViewController
            }

            guard let articleViewController = articleViewControllers
                .filter({ (avc) -> Bool in avc.title == category})
                .first as? CategoryArticlesViewController else {
                    let articleTableViewController = CategoryArticlesViewController()
                    articleTableViewController.title = category
                    articleTableViewController.delegate = self
                    return articleTableViewController
            }            
            return articleViewController
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //カテゴリごとの記事一覧を作成
        if articleVCDictionary.count == 0 {
            createArticlesViewControllers()
        }
        return categories.map({ category -> UIViewController? in
            guard let vc = articleVCDictionary[category] as? UIViewController else {
                return nil
            }
            return vc
        }).flatMap({$0})
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

