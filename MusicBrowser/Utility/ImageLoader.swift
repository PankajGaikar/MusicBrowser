//
//  ImageLoader.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageWithUrl(_ url: String) {

        let importedURL = URL(string: url)
        var imageURL: URL?
        let activityIndicator = UIActivityIndicatorView()
        
        // setup activityIndicator...
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageURL = importedURL

        image = nil
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: importedURL!, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if imageURL == importedURL {
                        self.image = imageToCache
                    }

                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                activityIndicator.stopAnimating()
            })
        }).resume()
    }
}
