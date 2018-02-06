//
//  CollectionViewController.swift
//  Project-Document-Manager
//
//  Created by Tony Cioara on 1/28/18.
//  Copyright © 2018 Tony Cioara. All rights reserved.
//

import Zip
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var unzippedImagesURL: URL?
    var collectionTitle: String?
    let fileManager = FileManager.default
    var files = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(collectionTitle!)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let files = try? fileManager.contentsOfDirectory(at: unzippedImagesURL!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        self.files = files!
        
    }
    
    func loadImage(fileURL: URL?) -> UIImage? {
        print("LOAD IMAGE")
        do {
            guard let fileURL = fileURL else {return nil}
            
            //            gets data from the url
            let imageData = try Data(contentsOf: fileURL)
            
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = loadImage(fileURL: files[indexPath.row])
        return cell
    }
}
