//
//  RemoteImageView.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/19/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

typealias CompletionClosure = ((URL?, Error?) -> Void)

class UIRemoteImageView: UIImageView {

    var currentContentURL: URL?
    
    func setContent(url: URL?) {
        if self.refreshContent(forNewUrl: url) {
            self.cleanCurrentConfiguration()
            if let url = url {
                self.currentContentURL = url
            
                if let image = self.cachedImage(forRemoteUrl: url) {
                    self.image = image
                } else {
                    let localUrl = self.localCachedImageUrl(forRemoteUrl: url)
                    NetworkingHelper.sharedInstance.executeDownloadContent(atUrl: url, saveAtUrl: localUrl, completionHandler: { (remoteUrl: URL, downloadedUrl: URL?, error: Error?) in
                        
                        if error != nil {
                            self.presentErrorMode()
                        } else {
                            FileSystemHelper.sharedInstance.copyFile(atUrl: downloadedUrl!,
                                                                     toUrl: localUrl)
                            DispatchQueue.main.async {
                                if let currentUrl = self.currentContentURL, currentUrl == url {
                                    print("downloaded \(url) to \(localUrl)")
                                    self.image = self.cachedImage(forRemoteUrl: url)!
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func refreshContent(forNewUrl newUrl: URL?) -> Bool {
        if self.image == nil {
            return true
        } else {
            if let currentURL = self.currentContentURL {
                return currentURL != newUrl
            } else {
                return true
            }
        }
    }
    
    // Mark: - Cache
    
    private func cachedImage(forRemoteUrl url: URL) -> UIImage? {
        let localUrl = self.localCachedImageUrl(forRemoteUrl: url)
        if FileSystemHelper.sharedInstance.existFile(atUrl: localUrl) {
            let path = localUrl.path
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    private func localCachedImageUrl(forRemoteUrl url: URL) -> URL {
        var localURL = FileSystemHelper.cachesPath()
        localURL.appendPathComponent(url.md5Hash())
        return localURL
    }
    
 
    
    // Mark: - States
    
    private func cleanCurrentConfiguration() {
        self.currentContentURL = nil
        self.image = nil
    }
    
    private func presentLoadingMode() {
        self.image = nil
    }
    
    private func presentErrorMode() {
        self.image = nil
    }
    
}
