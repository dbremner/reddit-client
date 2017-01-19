//
//  RedditAPI.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

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
    
    func top(after: String? = nil, count: Int = 0, time: RedditAPITime = .day, completionHandler: @escaping ((Array<Any>?, Error?) -> Void)) {
        
        let url = baseURL!.appendingPathComponent("r/all/top.json")
        
        var params = [String: String]()
        
        if let after = after
        {
            params["after"] = after
        }
        
        params["count"] = "\(count)"
        params["t"] = "\(time)"
        params["limit"] = "\(self.pageLimit)"
        
        NetworkingHelper.executeGETOperation(url, params: params) { (payload: Payload?, error: Error?) in
            
            print(payload ?? "there was some error")
            
        }
    }
}
