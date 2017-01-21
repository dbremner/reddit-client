//
//  LinkDetailsViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import WebKit

class LinkDetailsViewController: DetailsViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.setupWebView()
        super.viewDidLoad()
    }

    func setupWebView() {
       
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        self.view.addSubview(self.webView)
        
        self.webView.autoresizingMask = [.flexibleWidth,
                                         .flexibleHeight]
        
        self.webView.navigationDelegate = self
    }
    
    override func setup(withUrl url: URL) {
       
        self.presentLoadingMode()
        self.title = url.host
        let request = URLRequest(url: url)
        self.webView.load(request)
        self.currentURL = url
    }
    
    override func contentForActivityViewController() -> [Any] {
        return [NSURL(string: (self.currentURL?.absoluteString)!)!]
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.removeLoadingMode()
    }
    
    private func presentLoadingMode() {
      
        if self.spinner == nil
        {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.view.addSubview(spinner)
            
            spinner.startAnimating()
            spinner.center = CGPoint(x: self.view.bounds.size.width / 2.0,
                                     y: self.view.bounds.size.height / 2.0)
            
            spinner.autoresizingMask = [.flexibleBottomMargin,
                                        .flexibleLeftMargin,
                                        .flexibleRightMargin,
                                        .flexibleTopMargin]
            
            self.spinner = spinner
        }
    }
    
    private func removeLoadingMode() {
        
        if let spinner = self.spinner {
            spinner.removeFromSuperview()
        }
        self.spinner = nil
    }
    
}
