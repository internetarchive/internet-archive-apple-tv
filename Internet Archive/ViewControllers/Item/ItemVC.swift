//
//  ItemVC.swift
//  Internet Archive
//
//  Created by mac-admin on 5/29/18.
//  Copyright © 2018 mac-admin. All rights reserved.
//

import UIKit
import TvOSMoreButton
import TvOSTextViewer

class ItemVC: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtArchivedBy: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtDescription: TvOSMoreButton!
    @IBOutlet weak var itemImage: UIImageView!
    
    var iIdentifier: String?
    var iTitle: String?
    var iArchivedBy: String?
    var iDate: String?
    var iDescription: String?
    var iImageURL: URL?
    var iMediaType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPlay.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
        btnFavorite.setImage(UIImage(named: "favorite.png"), for: UIControlState.normal)
        btnFavorite.tag = 0
        
        txtTitle.text = iTitle
        txtArchivedBy.text = "Archived By:  \(iArchivedBy ?? "")"
        txtDate.text = "Date:  \(iDate ?? "")"
        txtDescription.text = iDescription
        itemImage.af_setImage(withURL: iImageURL!)
        txtDescription.buttonWasPressed = onMoreButtonPressed
    }

    @IBAction func onPlay(_ sender: Any) {
        let nc = self.navigationController as! BaseNC
        nc.openPlayer(identifier: iIdentifier!, title: iTitle!)
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if btnFavorite.tag == 0 {
            btnFavorite.setImage(UIImage(named: "favorited.png"), for: UIControlState.normal)
            btnFavorite.tag = 1
        } else {
            btnFavorite.setImage(UIImage(named: "favorite.png"), for: UIControlState.normal)
            btnFavorite.tag = 0
        }
        
        if let userData = Global.getUserData(),
            let email = userData["email"] as? String,
            let password = userData["password"] as? String {
            
            APIManager.sharedManager.saveFavoriteItem(email: email, password: password, identifier: iIdentifier!, mediatype: iMediaType!, title: iTitle!) { (_, _) in }
        } else {
            Global.showAlert(title: "Error", message: "Login is required", target: self)
        }
    }
    
    private func onMoreButtonPressed(text: String?) {
        guard let text = text else {
            return
        }
        
        let textViewerController = TvOSTextViewerViewController()
        textViewerController.text = text
        textViewerController.textEdgeInsets = UIEdgeInsets(top: 100, left: 250, bottom: 100, right: 250)
        present(textViewerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
