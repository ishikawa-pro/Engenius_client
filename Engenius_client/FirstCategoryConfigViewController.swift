//
//  FirstCategoryConfigViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/12/21.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import Foundation
import UIKit

class FirstCategorySelectViewController: ConfigCategoryViewController {
    @IBAction func moveMain(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextView = storyboard.instantiateViewController(withIdentifier: "EGViewController") as? EGViewController {
            show(nextView, sender: self)
        }
//        present(nextView!, animated: true, completion: nil)

    }
}
