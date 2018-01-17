//
//  ArticlesViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/12/27.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import XLPagerTabStrip

protocol ArticlesViewControllerDelegate {
    func showArticle(url: URL?)
}


protocol ArticlesViewController {
    var indicatorTitle: String? { get set }
    func fetchArticles()
    func downloadThumbnail(imageURL: URL, imageView: UIImageView)
    func setArticleCell(cell: ArticlesTableViewCell, article: Article ) -> ArticlesTableViewCell
}

extension ArticlesViewController where Self: UIViewController {
    func downloadThumbnail(imageURL: URL, imageView: UIImageView) {
        //2回目以降キャッシュが使われる
        imageView.af_setImage(withURL: imageURL) { (response) in
            switch (response.result) {
            case .success(let result):
                imageView.image = result
            case .failure(let error):
                print(error)
            }
        }
    }

    func setArticleCell(cell: ArticlesTableViewCell = ArticlesTableViewCell(), article: Article ) -> ArticlesTableViewCell {
        //再利用するcellの画像残っているので、デフォルトの画像に一旦差し替える。
        cell.thumbnailImageView.image =  UIImage(named: "81v2Ahk8X-L._SX355_.jpg")
        cell.titleLabel.text = article.title
        guard let url = article.imageURL else {
            return cell
        }
        downloadThumbnail(imageURL: url, imageView: cell.thumbnailImageView)
        return cell
    }
}


extension IndicatorInfoProvider where Self: ArticlesViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: indicatorTitle)
    }
}

