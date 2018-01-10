//
//  AlamofireClient.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/01/10.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import Alamofire

struct AlamofireClient: APIClientType {
    typealias URLRequestType = URLRequestConvertible
    func request(urlRequest: URLRequestConvertible, response: @escaping (Data) -> ()) {
        Alamofire.request(urlRequest).responseData { (ResponseData) in
            guard let data = ResponseData.data else {
                return
            }
            response(data)
        }
    }
}
