//
//  ViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //記事の取得用クラスHttp_helperのインスタンスの生成
    let http_helper = Http_helper.init(baseUrl: "http://localhost:3000/article.json")
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
        self.http_helper.getArticles(params: ["category":"Docker","limit":"10"])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //記事を取得したら呼ばれる
    func got_articles() -> Void {
        //記事を取得できた時点でtableViewを表示させる
        view.addSubview(self.articleTableView)
        
        //コンソール上に取得データを表示するデバッグ用コード
//        for data in self.http_helper.articles {
//            if let title = data["title"] as? String {
//                print(title)
//            }
//        }
    }
    
    //cellの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //記事の数に応じたcell数を返す
        return self.http_helper.articles.count
    }
    
    //各行に表示するcellを定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //cellの作成
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ArticlesTableViewCell
        
        //cellのtextLabelに取得した記事の情報を入れる
        cell.titleLabel.text =
            self.http_helper.articles[(indexPath as NSIndexPath).row]["title"] as? String
        return cell
    }

}

