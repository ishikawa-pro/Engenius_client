# Engenius
Engeniusは話題の技術ブログの記事を、一つのアプリで閲覧したいと思い作ってみました。  
名前は技術者(Engineer)の賢い(Genius)情報収集アプリを目指しているので、  
Engineer + Genius = Engeniusです笑

## Description 
|記事一覧画面|記事の閲覧画面|
|---|---|
|![](https://cloud.githubusercontent.com/assets/12871716/24652243/158b83ea-196c-11e7-839a-c3b578c7030d.png)|![](https://cloud.githubusercontent.com/assets/12871716/24652240/1297fcd6-196c-11e7-99e2-893abd8c3cad.png)|
---
![Alt text](https://cloud.githubusercontent.com/assets/12871716/24652125/8ebf3cd0-196b-11e7-9beb-bc92eaf25cdb.gif)

## Requirement
アプリをビルドする前にEngeniusのサーバーを起動し、サーバーサイドのipアドレスを調べて以下のファイルを修正してください。
* Engenius_Client/ViewController.swift  
    let http_helper = Http_helper(baseUrl: "http://サーバーのipアドレス:3000/article/categories.json")  
* Engenius_client/ArticlesTableViewController.swift  
    let http_helper = Http_helper.init(baseUrl: "http://サーバーのipアドレス:3000/article/show.json")  
