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
        
        if let after = after
        {
            params["after"] = after
        }
        
        params["count"] = "\(count)"
        params["t"] = "\(time)"
        params["limit"] = "\(self.pageLimit)"
        params["raw_json"] = "1"
        params["sort"] = "top"
        
        NetworkingHelper.sharedInstance.executeGETOperation(url, params: params) { (response: Payload?, error: Error?) in
            
            if error != nil {
    
                completionHandler(error)
    
            } else {
            
                self.processTop(response: response!, completionHandler: {
                    
                    completionHandler(nil)
                    
                })
            }
        }
    }
    
    private func processTop(response: Payload,
                            completionHandler: @escaping
        ((Void) -> Void)) {
        
        DataHelper.sharedInstance.performBackgroundTask { (context: NSManagedObjectContext) in
            
            Link.deleteAll(context: context)
            
            if let data = response["data"] as? Payload {
            
                if let children = data["children"] as? List {
            
                    var sortValue: Int32 = 1
                    
                    for child in children {
                
                        if let childData = child["data"] as? Payload {
                            let link = Link.create(withDictionary: childData,
                                                   context: context)
                            link.sortValue = sortValue
                            sortValue += 1
                        }
                    }
                }
            }
            
            try! context.save()
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
}
