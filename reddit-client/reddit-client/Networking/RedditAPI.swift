//
//  RedditAPI.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import CoreData

enum RedditAPITime: NSString {
    case hour = "hour"
    case day = "day"
    case week = "week"
    case month = "month"
    case year = "year"
    case all = "all"
}

class RedditAPI: NSObject {

    static let sharedInstance: RedditAPI = RedditAPI()
    
    let baseURL = URL(string: "https://www.reddit.com")
    let pageLimit = 25
    
    func top(after: String? = nil,
             count: Int = 0,
             time: RedditAPITime = .day,
             completionHandler: @escaping ((Error?) -> Void)) {
        
        let url = baseURL!.appendingPathComponent("top.json")
        var params = [String: String]()
        
        if let after = after {
            params["after"] = after
        }
        
        params["count"] = "\(count)"
        params["t"] = "\(time)"
        params["limit"] = "\(self.pageLimit)"
        params["raw_json"] = "1"
        params["sort"] = "top"
        
        NetworkingHelper.sharedInstance.executeGETOperation(url, params: params) { (response: Payload?, error: Error?) in
            
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            } else {
                self.processLinksResponse(response: response!,
                                          resetLocalData: (after == nil),
                                          count: count,
                                          completionHandler: {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    func nextPage(completionHandler: @escaping ((Error?) -> Void)) {
      
        let context = DataHelper.sharedInstance.viewContext()
        let link = Link.last(context: context)
        let count = Link.count(context: context)
        
        self.top(after: link.identifier,
                 count: count,
                 completionHandler: completionHandler)
    }
    
    private func processLinksResponse(response: Payload,
                                      resetLocalData: Bool,
                                      count: Int,
                                      completionHandler: @escaping ((Void) -> Void)) {
        
        DataHelper.sharedInstance.performBackgroundTask { (context: NSManagedObjectContext) in
            
            var newLinks = Set<Link>()
            
            if let data = response["data"] as? Payload {
            
                if let children = data["children"] as? List {
            
                    var sortValue = count
                    
                    for child in children {
                
                        if let childData = child["data"] as? Payload {
                            let link = Link.create(withDictionary: childData,
                                                   context: context)
                            link.sortValue = Int32(sortValue)
                            sortValue += 1
                            
                            newLinks.insert(link)
                        }
                    }
                }
            }
            
            if (resetLocalData)
            {
                // Remove only the ones that aren't in the news set
                let links = Link.findAll(context: context)
                
                for link in links {
                    if !newLinks.contains(link) {
                        context.delete(link)
                    }
                }
            }
            
            try! context.save()
            
            completionHandler()
        }
    }
}
