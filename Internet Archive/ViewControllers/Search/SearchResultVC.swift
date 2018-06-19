//
//  ViewController.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import UIKit
import AVKit

class SearchResultVC: UIViewController, UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var clsVideo: UICollectionView!
    @IBOutlet weak var clsMusic: UICollectionView!
    @IBOutlet weak var lblMovies: UILabel!
    @IBOutlet weak var lblMusic: UILabel!
    
    var videoItems = [[String: Any]]()
    var musicItems = [[String: Any]]()
    
    var query = "" {
        didSet {
            // Return if the filter string hasn't changed.
            let trimedQuery = query.trimmingCharacters(in: .whitespaces)
            guard trimedQuery != oldValue else { return }
            if trimedQuery.isEmpty { return }
            // Apply the filter or show all items if the filter string is empty.
            
            AppProgressHUD.sharedManager.show(view: self.view)
            videoItems.removeAll()
            musicItems.removeAll()
            
            clsVideo.isHidden = true
            clsMusic.isHidden = true
            lblMovies.isHidden = true
            lblMusic.isHidden = true
            
            let options = [
                "rows": "50",
                "fl[]" : "identifier,title,downloads,mediatype"
            ]
            
            APIManager.sharedManager.search(query: "\(trimedQuery) AND mediatype:(etree OR movies)", options: options, completion: { (data, error) in
                
                self.clsVideo.isHidden = false
                self.clsMusic.isHidden = false
                self.lblMovies.isHidden = false
                self.lblMusic.isHidden = false

                if let data = data {
                    let items = data["docs"] as! [[String : Any]]
                    
                    for item in items {
                        let mediaType = item["mediatype"] as! String
                        if mediaType == "movies" {
                            self.videoItems.append(item)
                        } else {
                            self.musicItems.append(item)
                        }
                    }
                }
                
                // Reload the collection view to reflect the changes.
                self.clsVideo.reloadData()
                self.clsMusic.reloadData()
                
                AppProgressHUD.sharedManager.hide()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clsVideo.isHidden = true
        clsMusic.isHidden = true
        lblMovies.isHidden = true
        lblMusic.isHidden = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text ?? ""
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clsVideo {
            return videoItems.count
        } else {
            return musicItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        
        var items = [[String: Any]]()
        
        if collectionView == clsVideo {
            items = videoItems
        } else {
            items = musicItems
        }
        
        itemCell.itemTitle.text = "\(items[indexPath.row]["title"]!)(\(items[indexPath.row]["downloads"]!)"
        
        let imageURL = URL(string: "https://archive.org/services/get-item-image.php?identifier=\(items[indexPath.row]["identifier"]!)")
        itemCell.itemImage.af_setImage(withURL: imageURL!)
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var items = [[String: Any]]()
        
        if collectionView == clsVideo {
            items = videoItems
        } else {
            items = musicItems
        }
        
        let identifier = items[indexPath.row]["identifier"] as! String
        let title = items[indexPath.row]["title"] as! String
        var filesToPlay = [[String: Any]]()
        
        AppProgressHUD.sharedManager.show(view: self.view)
        
        APIManager.sharedManager.getMetaData(identifier: identifier) { (data, err) in
            AppProgressHUD.sharedManager.hide()
            
            if let data = data {
                for file in data["files"] as! [[String: Any]] {
                    let filename = file["name"] as! String
                    let ext = filename.suffix(4)
                    
                    if ext == ".mp4" || ext == ".mp3" {
                        filesToPlay.append(file)
                    }
                }
                
                if filesToPlay.count == 0 {
                    Global.showAlert(title: "Error", message: "There is no playable content", target: self)
                    return
                }
                
                let filename = filesToPlay[0]["name"] as! String
                let url = "https://archive.org/download/\(identifier)/\(filename.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
                let mediaURL = URL(string: url)!
                let asset = AVAsset(url: mediaURL)
                let playerItem = AVPlayerItem(asset: asset)
                let playerViewController = AVPlayerViewController()
                
                let player = AVPlayer(playerItem: playerItem)
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            } else {
                Global.showAlert(title: "Error", message: "Error ocurred while downloading content", target: self)
            }
        }
    }
}


