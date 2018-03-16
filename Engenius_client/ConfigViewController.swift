//
//  ConfigViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/11/29.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit

class ConfigViewController: UITableViewController {
    var dismissionAction: (() -> Void)?
    var isChangeCategory = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true) {
            guard self.isChangeCategory else {
                return
            }
            self.dismissionAction?()
        }
    }
}
