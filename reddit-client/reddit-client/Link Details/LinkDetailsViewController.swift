//
//  LinkDetailsViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class LinkDetailsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var link: Link?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = (self.link!.url)!
        let url = URL(string: urlString)!
        
        self.title = url.host
        
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
    }

}
