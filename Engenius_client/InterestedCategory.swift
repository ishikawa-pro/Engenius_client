//
//  InterestedCategory.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/12/05.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import RealmSwift

class InterestedCategory: Object {
    @objc dynamic var category = ""

    func fetchInterestedCategory() -> [String] {
        //カテゴリの取得などは、viewDidApperでやらないと描画されるタイミング的にCellがうまく描画されない。
        do {
            let realm = try Realm()
            let selectedCategory:[String] = realm.objects(InterestedCategory.self).map { $0.category }
            return selectedCategory
        }
        catch (let e) {
            print(e)
            return []
        }
    }
}
