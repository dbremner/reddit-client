//
//  NetworkingHelper.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

typealias Payload = [String: AnyObject]

class NetworkingHelper: NSObject {

    static func executeGETOperation(_ url: URL, params: [String: String], completionHandler: @escaping ((Payload?, Error?) -> Void)) {
    
        let url = appendParams(url: url, params: params)
   
        print(url)
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                
                var json: Payload?
                var parseError: Error?
            
                do {
                    json = try JSONSerialization.jsonObject(with: data!) as? Payload
                } catch {
                    parseError = error
                }
                
                completionHandler(json, parseError)
            }
        })
        
        dataTask.resume()
    }
    
    static func executeDownloadContentOperation(_ URL: NSURL) {
    
    }
    
    // MARK: - Helper functions
    
    private static func appendParams(url: URL, params: [String: String]) -> URL {
        
        if params.count == 0 {
            return url
        }
        else {
        
            var queryItems = [URLQueryItem]()
      
            for (key, value) in params {
            
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = queryItems
            
            return urlComponents.url!
        }
    }
}
