//
//  Article.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/11/11.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation

struct Article : Codable {
    public let title: String
    public let url: URL?
    public let postDate: String
    public let imageURL: URL?
    public let category: String

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case postDate = "post_date"
        case imageURL = "image_url"
        case category
    }
}
