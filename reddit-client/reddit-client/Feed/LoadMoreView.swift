//
//  LoadMoreView.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class LoadMoreView: UIView {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var loadHandler: ((Void) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLoadingMode(false)
    }
    
    func setLoadingMode(_ loading: Bool) {
        self.button.isHidden = loading
        self.spinner.isHidden = !loading
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        if let loadHandler = self.loadHandler {
            loadHandler()
        }
    }
 
}

