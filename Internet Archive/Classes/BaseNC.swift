//
//  PlayerBaseNC.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/10/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MBProgressHUD

class BaseNC: UINavigationController, AVPlayerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoYearsVC(collection: String, title: String, identifier: String) -> Void {
        let yearsVC = self.storyboard?.instantiateViewController(withIdentifier: "YearsVC") as! YearsVC
        yearsVC.collection = collection
        yearsVC.name = title
        yearsVC.identifier = identifier
        
        self.pushViewController(yearsVC, animated: true)
    }
    
    func gotoYearItemsVC(year: String, items: [[String: Any]], collection: String) -> Void {
        let yearItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "YearItemsVC") as! YearItemsVC
        yearItemsVC.year = year
        yearItemsVC.items = items
        yearItemsVC.collection = collection
        
        self.pushViewController(yearItemsVC, animated: true)
    }
    
    func openPlayer(identifier: String, title: String) -> Void {
        var filesToPlay = [[String: Any]]()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        APIManager.sharedManager.getMetaData(identifier: identifier) { (data, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
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
                playerViewController.delegate = self
                
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
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willPresent interstitial: AVInterstitialTimeRange) {
        playerViewController.requiresLinearPlayback = true
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, didPresent interstitial: AVInterstitialTimeRange) {
        playerViewController.requiresLinearPlayback = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
