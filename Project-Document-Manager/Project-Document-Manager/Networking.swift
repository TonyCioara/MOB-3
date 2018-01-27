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

enum PhotoResult {
    case downloading(Double)
    case unzipping(Double)
    case error(String)
    case done(URL)
}

class Downloader {
    class func load(from url: URL, to localUrl: URL, completion: @escaping (PhotoResult) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    Zip.addCustomFileExtension("tmp")
                    try Zip.unzipFile(tempLocalUrl, destination: localUrl, overwrite: true, password: nil, progress: { (progress) -> () in
                        completion(PhotoResult.unzipping(progress))
                    }) // Unzip
                    completion(PhotoResult.done(localUrl))
                } catch (let writeError){
                    print("Error wirting file \(localUrl): \(writeError)")
                }
            } else {
                print("Failure %@", error?.localizedDescription ?? "")
            }
        }
        task.resume()
    }
}
