//
//  EGTableViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2018/04/10.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ArticlesTableViewController: UITableViewController, IndicatorInfoProvider {

    var indicatorTitle: String?

    var delegate: ArticlesViewControllerDelegate?

    var engeniusAPIClient: EngeniusAPIClient = EngeniusAPIClient(apiClient: AlamofireClient())
    //ページ数
    //オフセット数は、EngeniusAPIRouterで設定
    var page = 0
    //記事を取りに行っている否か
    var isFetching = false
    //記事の格納用
    var articles: [Article] = [] {
        didSet {
            //記事を追加読み込みする場合はreloadData
            //初めてTableViewを描画するときはaddSubview
            self.tableView.reloadData()
            if self.articles.count > EngeniusAPIRouter.article.limit {
                self.isFetching = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        // カスタムセルクラス名でnibを作成する
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "customCell")
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
        // Dispose of any resources that can be recreated.
    }

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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //記事の数に応じたcell数を返す
        return articles.count
    }

    //各行に表示するcellを定義
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //webViewControllerへ遷移する部分をデリゲートする。
        delegate?.showArticle(url: articles[indexPath.row].url)
        //選択状態を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ArticlesTableViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let row = indexPaths.last?.row else {
            return
        }
        //row + 1 はcellの数
        if row + 1 == articles.count && !isFetching {
            NotificationCenter.default.post(name: .fetchArticles, object: nil)
            isFetching = true
        }
    }
}

extension Notification.Name {
    static let fetchArticles = Notification.Name("fetchArticles")
}
