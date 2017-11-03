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
    let http_helper = Http_helper(baseUrl: "http://192.168.100.101:3000/article/categories.json")
    
    // インスタンス配列
    var articleViewControllers : [UIViewController] = []
    
    //表示する記事のURLを格納
    var articleURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        //ArticlesTableViewControllerの大元のインスタンスを作成
        var controller: ArticlesTableViewController
        
        //最新記事用のArticlesTableViewControllerを生成
        controller = ArticlesTableViewController(
            nibName: "ArticlesTableViewController",
            bundle: nil
        )
        controller.title = "最新記事"
        controller.delegate = self
        controllerArray.append(controller)
        
        //カテゴリごとの記事一覧を作成
        for category in categories {
            controller = ArticlesTableViewController(nibName: "ArticlesTableViewController", bundle: nil)
            controller.title = category
            controller.delegate = self
            controllerArray.append(controller)
        }

    }
    
    //ArticlesTableViewControllerからのデリゲート
    //セルをタップすると呼ばれる
    func showArticle(url: String) {
        self.articleURL = url
        //画面遷移
        self.performSegue(withIdentifier: "webView", sender: nil)
    }
    
    //遷移先に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webView"{
            let webViewController: WebViewController = segue.destination as! WebViewController
            webViewController.link = self.articleURL
//            if let indexPath = self.articleTableView.indexPathForSelectedRow{
//
//            }
        }
    }


}

