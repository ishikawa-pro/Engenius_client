//
//  http_helper.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/02/16.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import Alamofire

class Http_helper{
    //ベースURL格納用
    let baseUrl: String
    //取得した記事を格納
    var articles = [AnyObject]()
    //カテゴリを格納
    var categories = [AnyObject]()
    
    //初期化時にベースURLを設定
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getCategories() -> Void {
        Alamofire.request(self.baseUrl).responseJSON{ response in
            if let dict = response.result.value as? Array<AnyObject>{
                //articlesへ結果を格納
                self.categories = dict
                //articlesを取得したことを通知
                NotificationCenter.default.post(name: NSNotification.Name("gotCategories"),
                                                object: self)
            }
        }
    }
    
    //記事を取得
    func getArticles(params: Dictionary<String, String>) -> Void{
        Alamofire.request(self.baseUrl, parameters: params).responseJSON{ response in
            if let dict = response.result.value as? Array<AnyObject>{
                //articlesへ結果を格納
                self.articles = dict
                //articlesを取得したことを通知
                NotificationCenter.default.post(name: NSNotification.Name("gotArticles"),
                                                object: self)
            }
        }
    }
    
    //カテゴリに関係なく最新記事を取得
    func getLatestArticles(params: Dictionary<String, String>) -> Void{
        Alamofire.request("http://ec2-52-199-81-112.ap-northeast-1.compute.amazonaws.com:8000/article.json",parameters: params).responseJSON{ response in
            if let dict = response.result.value as? Array<AnyObject>{
                //articlesへ結果を格納
                self.articles = dict
                //articlesを取得したことを通知
                NotificationCenter.default.post(name: NSNotification.Name("gotArticles"),
                                                object: self)
            }
        }
    }
    

}
