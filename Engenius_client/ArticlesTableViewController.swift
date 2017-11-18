//
//  ArticlesTableViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/31.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

protocol articlesTableViewDelegate {
    func showArticle(url: String)
}

class ArticlesTableViewController: UIViewController, IndicatorInfoProvider,  UITableViewDelegate, UITableViewDataSource{
    var delegate: articlesTableViewDelegate!
    var masterViewPointer:ViewController?
    //追加取得する際にいくら飛ばすかを保存しておく
    var page = 1
    //スクロール中か判定用
    var isScrolling = false
    //記事の格納用
    //tableViewの宣言
    var articleTableView = UITableView()
    var articles: [Article] = [] {
        didSet {
            //記事を追加読み込みする場合はreloadData
            //初めてTableViewを描画するときはaddSubview
            if self.articles.count != 7 {
                self.articleTableView.reloadData()
                self.isScrolling = false
                return
            } else {
                //記事を取得できた時点でtableViewを表示させる
                view.addSubview(self.articleTableView)
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //tableViewの作成
        self.articleTableView = UITableView(frame: view.frame, style: .grouped)
        //tableViewのデリゲートを設定
        self.articleTableView.delegate = self
        //tableViewのデーターソースを設定
        self.articleTableView.dataSource = self
        //セルの高さを自動調整する
        self.articleTableView.estimatedRowHeight = 100
        self.articleTableView.rowHeight = UITableViewAutomaticDimension
        // サイズと位置調整
        self.articleTableView.frame = CGRect(
            x: 0,
            y: -35, //先頭セルにある謎の隙間を埋めるため
            width: self.view.frame.width,
            height: self.view.frame.height - 35 //先頭セルにある謎の隙間を埋めるため
        )
        
        // カスタムセルクラス名でnibを作成する
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        self.articleTableView.register(nib, forCellReuseIdentifier: "customCell")

        guard let vcTitle = title else {
            return
        }

        if vcTitle == "最新記事" {
            fetchArticles(request: EngeniusAPIRouter.article.fetchFeed(limit: 7, page: 0))
        } else {
            fetchArticles(request: EngeniusAPIRouter.article.fetchArticle(category: vcTitle, limit: 7, page: 0))
        }
    }

    func fetchArticles(request: URLRequestConvertible) {
        Alamofire.request(request).responseData { (response) in
            guard let data = response.data else {
                return
            }

            do {
                self.articles.append(
                    contentsOf: try JSONDecoder().decode([Article].self, from: data)
                )
            } catch {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let barTitle = title {
            return IndicatorInfo(title: barTitle)
        } else {
            return IndicatorInfo(title: "No title")
        }
    }
    
    //cellの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //記事の数に応じたcell数を返す
        return self.articles.count
    }
    
    //各行に表示するcellを定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //cellの作成
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ArticlesTableViewCell
        
        //cellのtextLabelに取得した記事の情報を入れる
        cell.setCell(titleText: (self.articles[(indexPath as NSIndexPath).row]["title"] as? String)!,
                     imageURL: (self.articles[(indexPath as NSIndexPath).row]["image_url"] as? String)!)
        
        
        return cell
    }
    
    //セルがタップされたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //webViewControllerへ遷移する部分をデリゲートする。
        delegate.showArticle(url:
            (self.articles[(indexPath as NSIndexPath).row]["link"] as? String)!)
    }
    
    //スクロールするたびに呼ばれる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //contentOffset.y + frame.size.height = UITableViewの高さ0からの変位量 + TableViewの高さ
        //contentSize.height = スクロールする中身の高さ
        //isDragging = ドラッグ中
        //UITableViewの高さ0からの変位量 + TableViewの高さ > スクロールする中身の高さ
        //スクロール中かどうか
        if self.articleTableView.contentOffset.y + self.articleTableView.frame.size.height >
            self.articleTableView.contentSize.height &&
            self.articleTableView.isDragging &&
            self.isScrolling == false
        {
            guard let vcTitle = title else {
                return
            }

            if vcTitle == "最新記事" {
                fetchArticles(request: EngeniusAPIRouter.article.fetchFeed(limit: 7, page: page))
            } else {
                fetchArticles(request: EngeniusAPIRouter.article.fetchArticle(category: vcTitle, limit: 7, page: page))
            }

            page += 1
            isScrolling = true
        }
    }
    
    
}
