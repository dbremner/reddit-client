//
//  LinkDetailsViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import WebKit

class LinkDetailsViewController: UIViewController {

    var webView: WKWebView!
    
    var link: Link?
    var currentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupWebView()
        
        if let link = self.link {
            let urlString = link.url!
            let url = URL(string: urlString)!
            
            self.setup(withUrl: url)
        }
    }

    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
//        webView.uiDelegate = self
        self.view.addSubview(self.webView)
        view = webView
    }
    
    func setup(withUrl url: URL) {
        self.title = url.host
        let request = URLRequest(url: url)
        self.webView.load(request)
        self.currentURL = url
    }
    
    // MARK: Restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        if let url = self.currentURL {
            coder.encode(url)
        }
            
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    
        if let url = coder.decodeObject() as? URL {
            self.setup(withUrl: url)
        }
    }
}
