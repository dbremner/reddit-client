//
//  DetailsViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

enum DetailsContentError: Error {
    case contentNotAvailableYet
}

class DetailsViewController: UIViewController {

    var currentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentURL = self.currentURL {
            self.setup(withUrl: currentURL)
        }
    }
    
    func setup(withUrl url: URL) {
        // Override!
    }
    
    // MARK: share
    
    func presentActivityViewController(forContent content: [Any]) {
        let vc = UIActivityViewController(activityItems: content, applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    func contentForActivityViewController() -> [Any] {
        // Override!
        return [Any]()
    }
    
    func checkIfContentIsReadyForActivityViewController() throws {
        // Override!
    }
    
    @IBAction func shareButtonTouched(_ sender: UIBarButtonItem) {
        
        do {
            try self.checkIfContentIsReadyForActivityViewController()
            self.presentActivityViewController(forContent: self.contentForActivityViewController())
        } catch {
            UIAlertController.presentAlert(withError: error,
                                           overViewController: self)
        }
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
