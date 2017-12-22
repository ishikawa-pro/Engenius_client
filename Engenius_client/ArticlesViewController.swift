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

class ArticlesTableViewController: UIViewController {

    var delegate: articlesTableViewDelegate!
    var masterViewPointer:EGViewController?
    var request: Alamofire.DataRequest?
    //ページ数
    //オフセット数は、EngeniusAPIRouterで設定
    private var page = 0
    //記事を取りに行っている否か
    var isFetching = false
    //記事の格納用
    //tableViewの宣言
    var articleTableView = UITableView()
    var articles: [Article] = [] {
        didSet {
            //記事を追加読み込みする場合はreloadData
            //初めてTableViewを描画するときはaddSubview
            if self.articles.count > EngeniusAPIRouter.article.limit {
                self.isFetching = false
                articleTableView.reloadData()
            } else {
                //記事を取得できた時点でtableViewを表示させる
                view.addSubview(articleTableView)
            }

            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //tableViewの作成
        articleTableView = UITableView(frame: view.frame, style: .grouped)
        //tableViewのデリゲートを設定
        articleTableView.delegate = self
        //tableViewのデーターソースを設定
        articleTableView.dataSource = self
        articleTableView.prefetchDataSource = self

        // カスタムセルクラス名でnibを作成する
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        articleTableView.register(nib, forCellReuseIdentifier: "customCell")
        fetchArticles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFetching {
            request?.resume()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isFetching {
            request?.suspend()
        }
    }

    func fetchArticles() {
        guard let vcTitle = title else {
            return
        }

        if vcTitle == "最新記事" {
            request = Alamofire.request(EngeniusAPIRouter.article.fetchFeed(categories: ["Swift", "機械学習", "Docker"], page: page))
        } else {
            request = Alamofire.request(EngeniusAPIRouter.article.fetchArticle(category: vcTitle, page: page))
        }
        request?.responseData { (response) in
            switch (response.result) {
                case .success(let data):
                    do {
                        let newArticle = try JSONDecoder().decode([Article].self, from: data)
                        //記事がなければappendせずにreturn
                        if newArticle.count == 0 {
                            //tableの終端でisFetchingをtrueにすることで新しい記事を取りに行けなくする。
                            self.isFetching = true
                            return
                        } else {
                            self.articles.append(contentsOf: newArticle)
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
            }
        }
        page += 1
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

    func setArticleCell(cell: ArticlesTableViewCell = ArticlesTableViewCell(), row: Int) -> ArticlesTableViewCell {
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

    //スクロールするたびに呼ばれる
    //スクロールが早すぎて、セルのpreFetchが行われない場合は、スクロールの終端を判定して新しい記事を取りに行く
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //contentOffset.y + frame.size.height = UITableViewの高さ0からの変位量 + TableViewの高さ
        //contentSize.height = スクロールする中身の高さ
        //isFetching = 記事を取りに行っているか
        //UITableViewの高さ0からの変位量 + TableViewの高さ > スクロールする中身の高さ
        //スクロール中かどうか
        if articleTableView.contentOffset.y + articleTableView.frame.size.height >
            articleTableView.contentSize.height &&
            articleTableView.isDragging && !isFetching {

            fetchArticles()
            isFetching = true

            //一番下まで行った時に全てのtableViewで残り50pointだけスクロールできない問題の暫定処置
            articleTableView.contentSize = CGSize.init(width: articleTableView.contentSize.width, height: articleTableView.contentSize.height + 95)
        }
    }
}

extension ArticlesTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    //セルがタップされたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //webViewControllerへ遷移する部分をデリゲートする。
        delegate.showArticle(url: articles[indexPath.row].url)
    }
}

extension ArticlesTableViewController : UITableViewDataSource {
    //各行に表示するcellを定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //cellの作成
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? ArticlesTableViewCell {
            return setArticleCell(cell: cell, row: indexPath.row)
        }
        return setArticleCell(row: indexPath.row)
    }

    //cellの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //記事の数に応じたcell数を返す
        return articles.count
    }

}

extension ArticlesTableViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let row = indexPaths.last?.row else {
            return
        }
        //row + 1 はcellの数
        if row + 1 == articles.count && !isFetching {
            fetchArticles()
            isFetching = true
            //最後のcellが50pt分だけスクロールできない問題の暫定措置
            articleTableView.contentSize = CGSize.init(width: articleTableView.contentSize.width, height: articleTableView.contentSize.height + 95)
        }
    }
}

extension ArticlesTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let barTitle = title {
            return IndicatorInfo(title: barTitle)
        } else {
            return IndicatorInfo(title: "No title")
        }
    }
}
