//
//  NetworkingHelper.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

typealias Payload = [String: AnyObject]
typealias List = [Payload]

class NetworkingHelper: NSObject {

    static let sharedInstance: NetworkingHelper = NetworkingHelper()
    lazy var sharedSession = URLSession.shared

    // MARK: - GET
    
    func executeGETOperation(_ url: URL,
                             params: [String: String],
                             completionHandler: @escaping ((Payload?, Error?) -> Void)) {
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = NetworkingHelper.appendParams(url: url, params: params)
       
        print("GET: \(url)")
        
        let request = URLRequest(url: url)
        
        let dataTask = self.sharedSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
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
    
    private static func appendParams(url: URL,
                                     params: [String: String]) -> URL {
        
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
    
    // MARK: - Download
    
    func executeDownloadContent(atUrl url: URL,
                                saveAtUrl: URL,
                                completionHandler: @escaping (URL, URL?, Error?) -> Void) {
        
        let downloadTask = self.sharedSession.downloadTask(with: url) { (downloadedUrl: URL?, response: URLResponse?, error: Error?) in
            completionHandler(url, downloadedUrl, error)
        }
        
        downloadTask.resume()
    }

}
