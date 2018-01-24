//
//  Networking.swift
//  Project-Document-Manager
//
//  Created by Tony Cioara on 1/22/18.
//  Copyright © 2018 Tony Cioara. All rights reserved.
//

import Foundation
import Zip

class Network {
    static let instance = Network()
    
    let fullPath = "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json"
    let session = URLSession.shared
    
    func fetch(completion: @escaping (Data) -> Void) {
        let pathURL = URL(string: fullPath)
        var request = URLRequest(url: pathURL!)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, resp, err) in
            
            if let data = data {
                completion(data)
            }
        }.resume()
    }
}

class Downloader {
    class func load(from url: URL, to localUrl: URL, completion: @escaping (URL) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    Zip.addCustomFileExtension("tmp")
                    try Zip.unzipFile(tempLocalUrl, destination: localUrl, overwrite: true, password: nil, progress: { (progress) -> () in
                        completion(URL.done(localUrl))
                    })
                }
            }
        }
    }
}
