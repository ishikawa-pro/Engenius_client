//
//  ArticlesTableViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/31.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AlamofireImage
import Alamofire

protocol articlesTableViewDelegate {
    func showArticle(url: URL?)
}

class ArticlesTableViewController: UIViewController, IndicatorInfoProvider,  UITableViewDelegate,
UITableViewDataSource,UITableViewDataSourcePrefetching {

    var delegate: articlesTableViewDelegate!
    var masterViewPointer:EGViewController?
    //追加取得する際にいくら飛ばすかを保存しておく
    var page = 1
    //スクロール中か判定用
    var isScrolling = false
    //記事の格納用
    //tableViewの宣言
    var articleTableView = UITableView()
    var articles: [Article] = [] {
        didSet {
            //記事を追加読み込みする場合はreloadData
            //初めてTableViewを描画するときはaddSubview
            if self.articles.count != 7 {
                self.articleTableView.reloadData()
                self.isScrolling = false
                return
            } else {
                //記事を取得できた時点でtableViewを表示させる
                view.addSubview(self.articleTableView)
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //tableViewの作成
        self.articleTableView = UITableView(frame: view.frame, style: .grouped)
        //tableViewのデリゲートを設定
        self.articleTableView.delegate = self
        //tableViewのデーターソースを設定
        self.articleTableView.dataSource = self
        articleTableView.prefetchDataSource = self

        // カスタムセルクラス名でnibを作成する
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        self.articleTableView.register(nib, forCellReuseIdentifier: "customCell")

        guard let vcTitle = title else {
            return
        }

        if vcTitle == "最新記事" {
            fetchArticles(request: EngeniusAPIRouter.article.fetchFeed(limit: 7, page: 0))
        } else {
            fetchArticles(request: EngeniusAPIRouter.article.fetchArticle(category: vcTitle, limit: 7, page: 0))
        }
    }

    func fetchArticles(request: URLRequestConvertible) {
        Alamofire.request(request).responseData { (response) in
            guard let data = response.data else {
                return
            }

            do {
                let newArticle = try JSONDecoder().decode([Article].self, from: data)
                //記事がなければappendせずにreturn
                if newArticle.count == 0 {
                    return
                } else {
                    self.articles.append(contentsOf: newArticle)
                }
            } catch {
                print(error)
            }
        }
    }

    private func downloadThumbnail(imageURL: URL, imageView: UIImageView) {
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

    private func setArticleCell(cell: ArticlesTableViewCell = ArticlesTableViewCell(), row: Int) -> ArticlesTableViewCell {
        //再利用するcellの画像残っているので、デフォルトの画像に一旦差し替える。
        cell.thumbnailImageView.image =  UIImage(named: "81v2Ahk8X-L._SX355_.jpg")
        cell.titleLabel.text = articles[row].title
        guard let url = articles[row].imageURL else {
            return cell
        }
        downloadThumbnail(imageURL: url, imageView: cell.thumbnailImageView)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let barTitle = title {
            return IndicatorInfo(title: barTitle)
        } else {
            return IndicatorInfo(title: "No title")
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    //cellの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //記事の数に応じたcell数を返す
        return self.articles.count
    }
    
    //各行に表示するcellを定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //cellの作成
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? ArticlesTableViewCell {
            return setArticleCell(cell: cell, row: indexPath.row)
        }
        return setArticleCell(row: indexPath.row)
    }

    //セルがタップされたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //webViewControllerへ遷移する部分をデリゲートする。
        delegate.showArticle(url: articles[indexPath.row].url)
    }
    
    //スクロールするたびに呼ばれる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //contentOffset.y + frame.size.height = UITableViewの高さ0からの変位量 + TableViewの高さ
        //contentSize.height = スクロールする中身の高さ
        //isDragging = ドラッグ中
        //UITableViewの高さ0からの変位量 + TableViewの高さ > スクロールする中身の高さ
        //スクロール中かどうか
        if self.articleTableView.contentOffset.y + self.articleTableView.frame.size.height >
            self.articleTableView.contentSize.height &&
            self.articleTableView.isDragging &&
            self.isScrolling == false
        {
            guard let vcTitle = title else {
                return
            }

            if vcTitle == "最新記事" {
                fetchArticles(request: EngeniusAPIRouter.article.fetchFeed(limit: 7, page: page))
            } else {
                fetchArticles(request: EngeniusAPIRouter.article.fetchArticle(category: vcTitle, limit: 7, page: page))
            }

            //一番下まで行った時に全てのtableViewで残り50pointだけスクロールできない問題の暫定処置
            articleTableView.contentSize = CGSize.init(width: articleTableView.contentSize.width, height: articleTableView.contentSize.height + 50)
            page += 1
            isScrolling = true
        }
    }
    
    
}
