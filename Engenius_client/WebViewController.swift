//
//  WebViewController.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/29.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var link:(String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openWeb()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToTableView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openWeb(){
        if let webData = link{
            if let url = NSURL(string:webData){
                let urlRequest = NSURLRequest(url: url as URL)
                webView.loadRequest(urlRequest as URLRequest)
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
