//
//  ArticlesViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/12/27.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import UIKit

protocol ArticlesViewControllerDelegate {
    func showArticle(url: URL?)
}


protocol ArticlesViewController {
    func fetchArticles()
    func downloadThumbnail(imageURL: URL, imageView: UIImageView)
    func setArticleCell(cell: ArticlesTableViewCell, row: Int) -> ArticlesTableViewCell
}

