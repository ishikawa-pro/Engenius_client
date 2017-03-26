//
//  ViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    //記事の取得用クラスHttp_helperのインスタンスの生成
    let http_helper = Http_helper.init(baseUrl: "http://localhost:3000/article.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //記事の取得通知を受け取るように登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.got_articles),
            name: NSNotification.Name("gotArticles"),
            object: nil
        )
        //記事を取得
        self.http_helper.getArticles(params: ["category":"Docker","limit":"3"])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //記事を取得したら呼ばれる
    func got_articles() -> Void {
        for data in self.http_helper.articles {
            if let title = data["title"] as? String {
                print(title)
            }
        }
    }

}

