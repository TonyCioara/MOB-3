//
//  ViewController.swift
//  Project-Document-Manager
//
//  Created by Tony Cioara on 1/22/18.
//  Copyright © 2018 Tony Cioara. All rights reserved.
//

import UIKit

struct ImageCollection: Codable {
    var collectionName: String
    var zippedImagesURL: String
    
    enum CodingKeys: CodingKey, String {
        case collectionName = "collection_name"
        case zippedImagesURL = "zipped_images_url"
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageCollections = [ImageCollection]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getImageCollection()
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

