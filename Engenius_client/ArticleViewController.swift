//
//  WebViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/29.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import SafariServices

class ArticleViewController: SFSafariViewController {
    var url:(String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openWeb()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToTableView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func openWeb(){        
        if let webData = url{
            if let url = URL(string:webData){
                let urlRequest = URLRequest(url: url)
                webView.loadRequest(urlRequest)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}