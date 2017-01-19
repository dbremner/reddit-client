//
//  Link+CoreDataProperties.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation
import CoreData


extension Link {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Link> {
        return NSFetchRequest<Link>(entityName: "Link");
    }

    @NSManaged public var author: String?
    @NSManaged public var commentsCount: Int64
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var identifier: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var sort: Int32

}
