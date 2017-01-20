//
//  LinkCell.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIRemoteImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    // Important: these values have to be in sync with IB
    static let padding: CGFloat = 8.0
    static let veritcalSpace: CGFloat = 4.0
    static let minHeight: CGFloat = 80.0
    static let titleFont = UIFont.systemFont(ofSize: 19.0, weight: UIFontWeightSemibold)
    static let thumbnailWidth: CGFloat = 63.0
    static let detailsHeight: CGFloat = 16.0
    static let commentsCountHeight: CGFloat = 16.0
    static let contentViewPadding: CGFloat = 1.0
    // --------------------------------------------------
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailImageView.layer.cornerRadius = 5.0
        self.thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(withLink link: Link) {
        self.titleLabel.text = LinkCell.titleText(forLink: link)
        self.detailsLabel.text = LinkCell.detailsText(forLink: link)
        self.commentsLabel.text = LinkCell.commentsCountText(forLink: link)
        
        if link.hasThumbnail() {
            self.thumbnailImageView.isHidden = false
            self.titleLabelLeadingConstraint.constant = LinkCell.thumbnailWidth + 2 * LinkCell.padding
            let url = URL(string: link.thumbnail!)!
            self.thumbnailImageView.setContent(url: url)
        } else {
            self.thumbnailImageView.isHidden = true
            self.titleLabelLeadingConstraint.constant = LinkCell.padding
            self.thumbnailImageView.setContent(url: nil)
        }
    }
    
    static func titleText(forLink link: Link) -> String {
        return link.title ?? ""
    }
    
    static func detailsText(forLink link: Link) -> String {
        if let author = link.author {
            return "\(link.createdAt!.friendlyDescription()) by \(author)"
        } else {
            return "\(link.createdAt!.friendlyDescription())"
        }
    }
    
    static func commentsCountText(forLink link: Link) -> String {
        return (link.commentsCount == 1 ?
            "\(link.commentsCount) comment" :
            "\(link.commentsCount) comments")
    }
    
    static func neededHeight(forLink link: Link) -> CGFloat {
        
        var maxSize = CGSize(width: UIScreen.main.bounds.width - 2 * padding,
                             height: .greatestFiniteMagnitude)
    
        if link.hasThumbnail() {
            maxSize.width -= (thumbnailWidth + padding)
        }

        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        
        let attributedTitle = NSAttributedString(string: LinkCell.titleText(forLink: link),
                                                 attributes: [NSFontAttributeName: titleFont])
        
        let titleRect = attributedTitle.boundingRect(with: maxSize,
                                                     options: options,
                                                     context: nil)
 
        let height = ceil(titleRect.height) + detailsHeight + commentsCountHeight + 2 * padding + 2 * veritcalSpace + contentViewPadding
        
        return (height < minHeight ? minHeight : height)
    }
}
