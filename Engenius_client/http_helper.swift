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
    
    //初期化時にベースURLを設定
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    //記事を取得
    func getArticles(params: Dictionary<String, String>) -> Void{
        //パラメータを設定
        let parameters: Parameters = params
        Alamofire.request(self.baseUrl, parameters: parameters).responseJSON{ response in
            if let dict = response.result.value as? Array<AnyObject>{
                //articlesへ結果を格納
                self.articles = dict
                //articlesを取得したことを通知
                NotificationCenter.default.post(name: NSNotification.Name("gotArticles"), object: self)
            }
        }
    }
    
    //サムネイルを取得
    func getThumbnail(urlString: String) -> UIImage {
        //URLセット
        let url = URL(string: urlString)!
        //画像の取得
        let imageData = try? Data(contentsOf: url)
        //UIImageへ代入
        let image = UIImage(data: imageData!)        
        return image!
    }
    

}
