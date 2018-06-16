//
//  FavoriteVC.swift
//  Internet Archive
//
//  Created by mac-admin on 5/30/18.
//  Copyright © 2018 mac-admin. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var clsMovie: UICollectionView!
    @IBOutlet weak var clsMusic: UICollectionView!
    @IBOutlet weak var clsPeople: UICollectionView!
    @IBOutlet weak var lblMovies: UILabel!
    @IBOutlet weak var lblMusic: UILabel!
    @IBOutlet weak var lblPeople: UILabel!
    
    var movieItems = [[String: Any]]()
    var musicItems = [[String: Any]]()
    var peoples = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clsMovie.isHidden = true
        self.clsMusic.isHidden = true
        self.clsPeople.isHidden = true
        self.lblMovies.isHidden = true
        self.lblMusic.isHidden = true
        self.lblPeople.isHidden = true
        
        if Global.isLoggedIn() {
            AppProgressHUD.sharedManager.show(view: self.view)
            
            APIManager.sharedManager.getFavoriteItems(username: Global.getUserData()!["username"] as! String)
            { (success, errCode, favorites) in
                
                if (success) {
                    
                    if let favorites = favorites, favorites.count > 0 {
                        var identifiers = [String]()
                        
                        for item in favorites {
                            if let mediaType = item["mediatype"] as? String {
                                if mediaType == "movies" || mediaType == "audio" || mediaType == "account" {
                                    identifiers.append(item["identifier"] as! String)
                                }
                            }
                        }
                        
                        let options = [
                            "fl[]" : "identifier,title,year,downloads,date,creator,description,mediatype",
                            "sort[]" : "date+desc"
                        ]
                        
                        let query = identifiers.joined(separator: " OR ")
                        
                        APIManager.sharedManager.search(query: "identifier:(\(query))", options: options, completion: { (data, error) in
                            
                            self.movieItems.removeAll()
                            self.musicItems.removeAll()
                            self.peoples.removeAll()
                            
                            if let data = data {
                                let items = data["docs"] as! [[String : Any]]
                                
                                for item in items {
                                    let mediaType = item["mediatype"] as! String
                                    if mediaType == "movies" {
                                        self.movieItems.append(item)
                                    } else if (mediaType == "audio") {
                                        self.musicItems.append(item)
                                    } else if (mediaType == "account") {
                                        self.peoples.append(item)
                                    }
                                }
                            }
                            
                            // Reload the collection view to reflect the changes.
                            self.clsMovie.reloadData()
                            self.clsMusic.reloadData()
                            self.clsPeople.reloadData()
                            self.clsMovie.isHidden = false
                            self.clsMusic.isHidden = false
                            self.clsPeople.isHidden = false
                            self.lblMovies.isHidden = false
                            self.lblMusic.isHidden = false
                            self.lblPeople.isHidden = false
                            
                            AppProgressHUD.sharedManager.hide()
                        })
                    } else {
                        
                    }
                    
                } else {
                    AppProgressHUD.sharedManager.hide()
                    Global.showAlert(title: "", message: "Error occured while downloading favorites \n \(errCode!)", target: self)
                }
            }
        } else {
            Global.showAlert(title: "Error", message: "Login is required", target: self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clsMovie {
            return movieItems.count
        } else if collectionView == clsMusic {
            return musicItems.count
        } else if collectionView == clsPeople {
            return peoples.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        
        var items = [[String: Any]]()
        
        if collectionView == clsMovie {
            items = movieItems
        } else if collectionView == clsMusic {
            items = musicItems
        } else if collectionView == clsPeople {
            items = peoples
        }
        
        let imageURL = URL(string: "https://archive.org/services/get-item-image.php?identifier=\(items[indexPath.row]["identifier"]!)")
        itemCell.itemTitle.text = "\(items[indexPath.row]["title"]!)"
        itemCell.itemImage.af_setImage(withURL: imageURL!)
        
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var items = [[String: Any]]()
        let nc = self.navigationController as? BaseNC
        
        if collectionView == clsPeople {
            items = peoples
            
            let data = items[indexPath.row]
            let identifier = data["identifier"] as? String
            let title = data["title"] as? String
            nc?.gotoPeopleVC(identifier: identifier, title: title)
        } else {
            if collectionView == clsMovie {
                items = movieItems
            } else if collectionView == clsMusic {
                items = musicItems
            }
            
            let data = items[indexPath.row]
            let identifier = data["identifier"] as? String
            let title = data["title"] as? String
            let archivedBy = data["creator"] as? String
            let date = data["date"] as? String
            let description = data["description"] as? String
            let mediaType = data["mediatype"] as? String
            let imageURL = URL(string: "https://archive.org/services/get-item-image.php?identifier=\(data["identifier"] as! String)")
            
            nc?.gotoItemVC(identifier: identifier, title: title, archivedBy: archivedBy, date: date, description: description, mediaType: mediaType, imageURL: imageURL)
        }
    }
    
}
