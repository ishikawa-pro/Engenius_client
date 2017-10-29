//
//  ArticlesTableViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/31.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit

protocol articlesTableViewDelegate {
    func showArticle(url: String)
}

class ArticlesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var delegate: articlesTableViewDelegate!
    var masterViewPointer:ViewController?
    //追加取得する際にいくら飛ばすかを保存しておく
    var offset = 7
    //スクロール中か判定用
    var isScrolling = false
    //記事の格納用
    var articles: [AnyObject] = []
    //記事の取得用クラスHttp_helperのインスタンスの生成
    let http_helper = Http_helper.init(baseUrl: "http://ec2-52-199-81-112.ap-northeast-1.compute.amazonaws.com:8000/article/show.json")
    //tableViewの宣言
    var articleTableView = UITableView()
    
    
    //nibファイルをパラメタにとるイニシャライザinit
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        
        //記事の取得通知を受け取るように登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.got_articles),
            name: NSNotification.Name("gotArticles"),
            object: nil
        )
        //記事を取得
        if let title_str = title {
            if title_str == "最新記事" {
                self.http_helper.getLatestArticles(params: ["limit":"7"])
            } else {
                self.http_helper.getArticles(params: ["category":self.title!,"limit":"7"])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //記事を取得したら呼ばれる
    func got_articles() -> Void {
        //取得した記事をarticlesへ格納
        for article in self.http_helper.articles{
            self.articles.append(article)
        }
        //記事を追加読み込みする場合はreloadData
        //初めてTableViewを描画するときはaddSubview
        if self.articles.count != 7 {
            self.articleTableView.reloadData()
            self.isScrolling = false
            return
        }else{
            //記事を取得できた時点でtableViewを表示させる
            view.addSubview(self.articleTableView)
            return
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
            if let title_str = title {
                if title_str == "最新記事" {
                    self.http_helper.getLatestArticles(params: ["limit":"7","offset":   (String(self.offset))])
                } else {
                    self.http_helper.getArticles(params: ["category":self.title!,"limit":"7","offset":(String(self.offset))])
                }
            }

            self.offset += 7
            self.isScrolling = true
        }
    }
    
    
}
