//
//  ConfigCategoryViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/11/29.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class ConfigCategoryViewController: UITableViewController, UINavigationControllerDelegate {
    var isChangeCategory = false
    var categories : Category? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        //cateogryの取得
        Alamofire.request(EngeniusAPIRouter.category.getCategories()).responseData { (response) in
            switch (response.result) {
                case .success(let data):
                    do {
                        self.categories = try JSONDecoder().decode(Category.self, from: data)
                    } catch {
                        print("error")
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.categories.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath)
        cell.textLabel?.text = categories?.categories[indexPath.row]
        cell.accessoryType = .none
        do {
            let realm = try Realm()
            guard let category = cell.textLabel?.text else {
                return cell
            }
            let interestedCategory = realm.objects(InterestedCategory.self).filter("category = %@", category)
            if interestedCategory.count == 1 {
                cell.accessoryType = .checkmark
            }
        }
        catch (let e)
        {
            print(e)
        }
        return cell
    }

    // セルが選択された時に呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let realm = try Realm()
            guard let cell = tableView.cellForRow(at:indexPath), let title = cell.textLabel?.text else {
                return
            }
            switch (cell.accessoryType) {
            case .none:
                let interestedCategory = InterestedCategory()
                interestedCategory.category = title
                cell.accessoryType = .checkmark
                isChangeCategory = true
                try realm.write {
                    realm.add(interestedCategory)
                }
            case .checkmark:
                let interestedCategory = realm.objects(InterestedCategory.self).filter("category = %@", title)
                cell.accessoryType = .none
                isChangeCategory = true
                try realm.write {
                    realm.delete(interestedCategory)
                }
            default:
                break
            }
            cell.isSelected = false
        }
        catch (let e){
            print(e)
        }
    }

    //navigationControllerが持つViewControllerのviewが表示される時に呼ばれる。
    //UINavigationControllerDelegateのdelegate method
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let configVC = viewController as? ConfigViewController {
            configVC.isChangeCategory = isChangeCategory
        }
    }
}
