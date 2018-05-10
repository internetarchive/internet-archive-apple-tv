//
//  ViewController.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import UIKit

class YearItemsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [[String: Any]]()
    var year = ""
    var collection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtTitle.text = year
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        
        itemCell.itemTitle.text = items[indexPath.row]["title"] as? String
        let imageURL = URL(string: "https://archive.org/services/get-item-image.php?identifier=\(items[indexPath.row]["identifier"] as! String)")
        itemCell.itemImage.af_setImage(withURL: imageURL!)
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nc = self.navigationController as! BaseNC
        let identifier = items[indexPath.row]["identifier"] as! String
        let title = items[indexPath.row]["title"] as! String
        nc.openPlayer(identifier: identifier, title: title)
    }
    
}


