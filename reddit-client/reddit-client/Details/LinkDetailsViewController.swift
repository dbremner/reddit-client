//
//  LinkDetailsViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import WebKit

class LinkDetailsViewController: DetailsViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        self.setupWebView()
        super.viewDidLoad()
    }

    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        self.view.addSubview(self.webView)
    }
    
    override func setup(withUrl url: URL) {
        self.title = url.host
        let request = URLRequest(url: url)
        self.webView.load(request)
        self.currentURL = url
    }
    
    override func contentForActivityViewController() -> [Any] {
        return [NSURL(string: (self.currentURL?.absoluteString)!)!]
    }
}
