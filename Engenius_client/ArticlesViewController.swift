//
//  ArticlesViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/02/20.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class ArticlesViewController: UIViewController, IndicatorInfoProvider {        
    
    var indicatorTitle: String?

    var delegate: ArticlesViewControllerDelegate?

    var engeniusAPIClient: EngeniusAPIClient = EngeniusAPIClient(apiClient: AlamofireClient())
    //ページ数
    //オフセット数は、EngeniusAPIRouterで設定
    var page = 0
    //記事を取りに行っている否か
    var isFetching = false
    //記事の格納用
    //tableViewの宣言
    var articleTableView: UITableView?
    var selectedCategory: [String] = []
    var articles: [Article] = [] {
        didSet {
            //記事を追加読み込みする場合はreloadData
            //初めてTableViewを描画するときはaddSubview
            if self.articles.count > EngeniusAPIRouter.article.limit {
                self.isFetching = false
                articleTableView?.reloadData()
            } else {
                //記事を取得できた時点でtableViewを表示させる
                if let tabelView = articleTableView {
                    view.addSubview(tabelView)
                }
            }
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewの作成
        articleTableView = UITableView(frame: view.frame)
        //tableViewのデリゲートを設定
        articleTableView?.delegate = self
        //tableViewのデーターソースを設定
        articleTableView?.dataSource = self
        articleTableView?.prefetchDataSource = self

        // カスタムセルクラス名でnibを作成する
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        articleTableView?.register(nib, forCellReuseIdentifier: "customCell")        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFetching {
            //request?.resume()
            engeniusAPIClient.apiClient.resume()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isFetching {
            //request?.suspend()
            engeniusAPIClient.apiClient.suspend()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Notification.Name {
    static let fetchArticles = Notification.Name("fetchArticles")
}

extension ArticlesViewController : UIScrollViewDelegate {
    //スクロールするたびに呼ばれる
    //スクロールが早すぎて、セルのpreFetchが行われない場合は、スクロールの終端を判定して新しい記事を取りに行く
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //contentOffset.y + frame.size.height = UITableViewの高さ0からの変位量 + TableViewの高さ
        //contentSize.height = スクロールする中身の高さ
        //isFetching = 記事を取りに行っているか
        //UITableViewの高さ0からの変位量 + TableViewの高さ > スクロールする中身の高さ
        //スクロール中かどうか
        guard let tableView = articleTableView else {
            return
        }
        if tableView.contentOffset.y + tableView.frame.size.height >
            tableView.contentSize.height &&
            tableView.isDragging && !isFetching {

            NotificationCenter.default.post(name: .fetchArticles, object: nil)

            isFetching = true

            //一番下まで行った時に全てのtableViewで残り50pointだけスクロールできない問題の暫定処置
            tableView.contentSize = CGSize.init(width: tableView.contentSize.width, height: tableView.contentSize.height + 145)
        }
    }
}

extension ArticlesViewController : UITableViewDelegate {
    //セルがタップされたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //webViewControllerへ遷移する部分をデリゲートする。
        delegate?.showArticle(url: articles[indexPath.row].url)
    }
}

extension ArticlesViewController : UITableViewDataSource {
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

    //各行に表示するcellを定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //cellの作成
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ArticlesTableViewCell

        //再利用するcellの画像残っているので、デフォルトの画像に一旦差し替える。
        cell.thumbnailImageView.image =  UIImage(named: "81v2Ahk8X-L._SX355_.jpg")
        cell.titleLabel.text = articles[indexPath.row].title
        guard let url = articles[indexPath.row].imageURL else {
            return cell
        }
        downloadThumbnail(imageURL: url, imageView: cell.thumbnailImageView)

        return cell
    }

    //cellの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //記事の数に応じたcell数を返す
        return articles.count
    }
}

extension ArticlesViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let row = indexPaths.last?.row else {
            return
        }
        //row + 1 はcellの数
        if row + 1 == articles.count && !isFetching {
            NotificationCenter.default.post(name: .fetchArticles, object: nil)
            isFetching = true
            //最後のcellが50pt分だけスクロールできない問題の暫定措置
            guard let tableView = articleTableView else {
                return
            }
            tableView.contentSize = CGSize.init(width: tableView.contentSize.width, height: tableView.contentSize.height + 145)
        }
    }
}


