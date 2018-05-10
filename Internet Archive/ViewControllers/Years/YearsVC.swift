//
//  ViewController.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import UIKit
import MBProgressHUD
import AlamofireImage

class YearsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var name = ""
    var identifier = ""
    var collection = ""
    var sortedData:[String: [[String: Any]]] = [:]
    var sortedKeys = [String]()
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtTitle.text = name
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIManager.sharedManager.getCollections(collection: identifier, result_type: collection, limit: nil) { (collection, data, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = data {
                self.collection = collection
                
                for item in data {
                    var year = "Undated"
                    
                    if item["year"] != nil {
                        year = (item["year"] as? String)!
                    }
                    
                    if self.sortedData[year] == nil {
                        self.sortedData[year] = [[String: Any]]()
                    } else {
                        self.sortedData[year]!.append(item)
                    }
                }
                
                self.sortedKeys = self.sortedData.keys.sorted(by: { (a, b) -> Bool in
                    return a < b
                })
                
                self.collectionView?.reloadData()
            } else {
                Global.showAlert(title: "Error", message: "Error occurred while downloading videos", target: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        
        itemCell.itemTitle.text = sortedKeys[indexPath.row]
        let imageURL = URL(string: "https://archive.org/services/get-item-image.php?identifier=\(identifier)")
        itemCell.itemImage.af_setImage(withURL: imageURL!)
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nc = self.navigationController as! BaseNC
        nc.gotoYearItemsVC(year: sortedKeys[indexPath.row], items: sortedData[sortedKeys[indexPath.row]]!, collection: collection)
    }
}


