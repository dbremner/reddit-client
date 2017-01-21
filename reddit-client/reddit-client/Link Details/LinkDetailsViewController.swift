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
    var currentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let link = self.link {
            let urlString = link.url!
            let url = URL(string: urlString)!
            
            self.setup(withUrl: url)
        }
    }

    func setup(withUrl url: URL) {
        self.title = url.host
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
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
