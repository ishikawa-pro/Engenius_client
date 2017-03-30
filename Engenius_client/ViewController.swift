//
//  ViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //追加取得する際にいくら飛ばすかを保存しておく
    var offset = 7
    //スクロール中か判定用
    var isScrolling = false
    //記事の格納用
    var articles: [AnyObject] = []
    //記事の取得用クラスHttp_helperのインスタンスの生成
    let http_helper = Http_helper.init(baseUrl: "http://192.168.22.124:3000/article/show.json")
    //tableViewの宣言
    var articleTableView = UITableView()
    
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
        self.http_helper.getArticles(params: ["category":"機械学習","limit":"7"])

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
    
    //遷移先に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webView"{
            if let indexPath = self.articleTableView.indexPathForSelectedRow{
                let webViewController: WebViewController = segue.destination as! WebViewController
                webViewController.link = self.articles[(indexPath as NSIndexPath).row]["link"] as? String
            }
        }
    }
    
    //セルがタップされたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面を遷移する
        self.performSegue(withIdentifier: "webView", sender: nil)
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
            self.http_helper.getArticles(params: ["category":"機械学習","limit":"7","offset":(String(self.offset))])
            self.offset += 7
            self.isScrolling = true
        }
    }


}

