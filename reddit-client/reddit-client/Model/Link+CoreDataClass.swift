//
//  Link+CoreDataClass.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation
import CoreData

@objc(Link)
public class Link: NSManagedObject {
    
    static func create(withDictionary dictionary: Payload, context: NSManagedObjectContext) -> Link {
        
        let linkIdentifier = Link.identifier(fromDictionary: dictionary)
        
        var link = Link.find(withIdentifier: linkIdentifier, context: context)
     
        if link == nil {
            link = Link(context: context)
        }
        
        link?.update(withIdentifier: dictionary)
        
        return link!
    }
    
    static func find(withIdentifier identifier: String, context: NSManagedObjectContext) -> Link? {
        
        let request: NSFetchRequest<Link> = Link.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var searchResults: Array<Link>?
        
        context.performAndWait {
            
            do {
                searchResults = try context.fetch(request)
            } catch {
                fatalError("Error with request: \(error)")
            }
            
        }
        
        return searchResults?.first
    }
    
    static func deleteAll(context: NSManagedObjectContext) {
        
        let request: NSFetchRequest<Link> = Link.fetchRequest()
        var searchResults: Array<Link>?
        
        context.performAndWait {
            
            do {
                searchResults = try context.fetch(request)
                
                for link in searchResults! {
                    context.delete(link)
                }
                
            } catch {
                fatalError("Error with request: \(error)")
            }
        }
    }
    
    static func identifier(fromDictionary dictionary: Payload) -> String {
        return dictionary["name"] as! String
    }
    
    func update(withIdentifier dictionary: [String: Any]) {
        
        if let title = dictionary["title"] as? String {
            self.title = title
        } else {
            self.title = nil
        }
        
        if let author = dictionary["author"] as? String {
            self.author = author
        } else {
            self.author = nil
        }
        
        if let commentsCount = dictionary["num_comments"] as? Int64 {
            self.commentsCount = commentsCount
        } else {
            self.commentsCount = 0
        }
        
        if let created = dictionary["created"] as? TimeInterval {
            self.createdAt = NSDate(timeIntervalSince1970: created)
        } else {
            self.createdAt = nil
        }
        
        if let identifier = dictionary["name"] as? String {
            self.identifier = identifier
        } else {
            self.identifier = nil
        }
        
        if let thumbnail = dictionary["thumbnail"] as? String {
            self.thumbnail = (thumbnail.hasPrefix("http") ? thumbnail : nil)
        } else {
            self.thumbnail = nil
        }
        
        if let url = dictionary["url"] as? String {
            self.url = url
        } else {
            self.url = nil
        }
        
    }
    
    func hasThumbnail() -> Bool {
        if let thumbnail = self.thumbnail {
            return !thumbnail.isEmpty
        } else {
            return false;
        }
    }
}
