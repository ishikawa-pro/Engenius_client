//
//  ViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ViewController: ButtonBarPagerTabStripViewController, articlesTableViewDelegate{
    //カテゴリの取得用
    let http_helper = Http_helper(baseUrl: "http://ec2-52-199-81-112.ap-northeast-1.compute.amazonaws.com:8000/article/categories.json")
    
    // インスタンス配列
    var articleViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //カテゴリの取得通知を受け取るように登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.gotCategories),
            name: NSNotification.Name("gotCategories"),
            object: nil
        )
        //カテゴリを取得
        self.http_helper.getCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    //カテゴリを取得したら呼ばれる
    //ここでPageMenuを生成する
    func gotCategories() ->  Void{
        // categoryリスト
        var categories:[String] = []
        //取得したカテゴリリストをcategoriesへ格納
        for category in self.http_helper.categories {
            categories.append(category["category"] as! String)
        }

        var articleViewController: ArticlesTableViewController
        
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
    
    //ArticlesTableViewControllerからのデリゲート
    //セルをタップすると呼ばれる
    func showArticle(url: String) {
        performSegue(withIdentifier: "WebViewController", sender: url)
    }

    //遷移先に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController,
            let url = sender as? String {
            vc.url = url
        }
    }


}

