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
    let base_url: String
    var articles = [AnyObject]()
    
    init(base_url: String) {
        self.base_url = base_url
    }
    
    func get_articles(params: Dictionary<String, String>) -> Void{
        let parameters: Parameters = params
        Alamofire.request(self.base_url, parameters: parameters).responseJSON{ response in
            if let dict = response.result.value as? Array<AnyObject>{
                //articlesへ結果を格納
                self.articles = dict
                //articlesを取得したことを通知
                NotificationCenter.default.post(name: NSNotification.Name("got_articles"), object: self)
            }
        }
    }
    

}
