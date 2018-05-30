//
//  YearsVC.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage

class YearsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var name = ""
    var identifier = ""
    var collection = ""
    var sortedData:[String: [[String: Any]]] = [:]
    var sortedKeys = [String]()
    
    private var selectedRow = 0
    private let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = true
        collectionView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        
        APIManager.sharedManager.getCollections(collection: identifier, result_type: collection, limit: nil) { (collection, data, err) in
            SVProgressHUD.dismiss()
            
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
                
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.collectionView.isHidden = false
            } else {
                Global.showAlert(title: "Error", message: "Error occurred while downloading videos", target: self)
            }
        }
    }
    
    // MARK: - UITableView datasource, delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let yearCell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath) as! YearCell
        yearCell.lblYear.text = sortedKeys[indexPath.row]
        
        return yearCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView datasource, delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sortedData.count == 0 {
            return 0
        } else {
            return (sortedData[sortedKeys[selectedRow]]?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let data = sortedData[sortedKeys[selectedRow]]![indexPath.row]
        itemCell.itemTitle.text = data["title"] as? String
        let imageURL = URL(string: "https://archive.org/services/get-item-image.php?identifier=\(data["identifier"] as! String)")
        itemCell.itemImage.af_setImage(withURL: imageURL!)
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let nc = self.navigationController as! BaseNC
//        nc.gotoYearItemsVC(year: sortedKeys[indexPath.row], items: sortedData[sortedKeys[indexPath.row]]!, collection: collection)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width / 4) - 100
        let height = width + 145
        let cellSize = CGSize(width: width, height: height)
        return cellSize
    }
}


