//
//  AlamofireClient.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/01/10.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import Alamofire

final class AlamofireClient: APIClientType {
    typealias URLRequestType = URLRequestConvertible
    private var dataRequest: Alamofire.DataRequest?
    func request(urlRequest: URLRequestType, response: @escaping (Data?) -> ()) {
        dataRequest = Alamofire.request(urlRequest)
        dataRequest?.responseData { (responseData) in
            switch (responseData.result) {
                case .success(let data):
                    response(data)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
