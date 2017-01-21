//
//  ImageDetailsViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class ImageDetailsViewController: DetailsViewController {

    @IBOutlet weak var imageView: UIRemoteImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title = "Image"
    }
    
    override func setup(withUrl url: URL) {
        self.imageView.setContent(url: url)
    }
    
    override func contentForActivityViewController() -> [Any] {
        return [self.imageView.image!]
    }
    
    override func checkIfContentIsReadyForActivityViewController() throws {
        if self.imageView.image == nil {
            let error = NSError(domain: "DetailsContent",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Content not available yet"])
            throw error
        }
    }
}
