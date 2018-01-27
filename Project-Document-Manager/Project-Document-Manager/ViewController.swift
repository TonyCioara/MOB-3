//
//  ViewController.swift
//  Project-Document-Manager
//
//  Created by Tony Cioara on 1/22/18.
//  Copyright © 2018 Tony Cioara. All rights reserved.
//

import UIKit

struct ImageCollection {
    var collectionName: String
    var zippedImagesURL: URL
    var unzippedImagesURL: URL?
    var unzippingProgress: Double?
}

extension ImageCollection: Decodable {
    
    enum Keys: String, CodingKey {
        case collectionName = "collection_name"
        case zippedImagesURL = "zipped_images_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let collectionName = try container.decode(String.self, forKey: .collectionName)
        let zippedImagesURL = try container.decode(URL.self, forKey: .zippedImagesURL)
        self.init(collectionName: collectionName, zippedImagesURL: zippedImagesURL, unzippedImagesURL: nil, unzippingProgress: nil)
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageCollections = [ImageCollection]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getImageCollection()
        self.downloadAndUnzipFiles()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    func getImageCollection() {
        Network.instance.fetch() { (data) in
            DispatchQueue.main.async {
                if let jsonImageCollections = try? JSONDecoder().decode([ImageCollection].self, from: data) {
                    self.imageCollections = jsonImageCollections
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func downloadAndUnzipFiles() {
        
//        File manager settings
        let fileManager = FileManager.default
        
//        File url where saving unzipped file
        let fileUrl = try! fileManager.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
//        Index of list collections
        var index = 0
        
//        Loop through list of collections
        for collection in self.imageCollections {
            
//            Download zipped file from an image url and save unzipped file to file url
            Downloader.load(from: collection.zippedImagesURL, to: fileUrl, completion: {(result) in
                switch result {
                    
//                  When result is filepath unzipped file
                case let .done(filePath):
                    DispatchQueue.main.async {
                        
//                        Gets an unzipped file name from a zipped image url
                        let filename = self.imageCollections[index].zippedImagesURL.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "+", with: " ")
                        
//                        Saves an unzipped image url
                        self.imageCollections[index].unzippedImagesURL = filePath.appendingPathComponent(filename)
                        
//                        Increment number of index
                        index += 1
                        
//                        Updates tableview cells
                        self.tableView.reloadData()
                    }
                case let .downloading(progress):
                    print(progress)
                case let .unzipping(progress):
                    self.imageCollections[index].unzippingProgress = progress
                case let .error(error):
                    print(error)
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewImageCell", for: indexPath) as! PreviewImageCell
        cell.titleLabel.text = imageCollections[indexPath.row].collectionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageCollections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

