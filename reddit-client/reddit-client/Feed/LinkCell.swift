//
//  LinkCell.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLabelLeadingConstraint: NSLayoutConstraint!
   @IBOutlet weak var detailsLabelHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(withLink link: Link) {
       
        self.titleLabel.text = link.title ?? ""
        
        if let author = link.author {
            self.detailsLabel.text = "submitted \(link.createdAt!.friendlyDescription()) by \(author)"
        } else {
            self.detailsLabel.text = "submitted \(link.createdAt!.friendlyDescription())"
        }
    }
    
    static func neededHeight(forLink link: Link) -> CGFloat {
    
        return 88.0
      
    }
}
