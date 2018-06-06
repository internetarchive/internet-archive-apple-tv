//
//  TabbarController.swift
//  Internet Archive
//
//  Created by mac-admin on 6/5/18.
//  Copyright © 2018 mac-admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    private func getFavorites() {
        
    }
    
    private func loginCheck() {
        if !Global.isLoggedIn() {
            return
        }
        
        if let userData = Global.getUserData(),
            let email = userData["email"] as? String,
            let password = userData["password"] as? String {
            
            SVProgressHUD.show()
            
            APIManager.sharedManager.login(email: email, password: password) { (data) in
                
                SVProgressHUD.dismiss()
                
                if data == nil {
                    Global.showAlert(title: "Error", message: Errors[400]!, target: self)
                    return
                }
                
                if let success = data!["success"] as? Bool, !success {
                    Global.showAlert(title: "Error", message: Errors[302]!, target: self)
                    return
                }
            }
        }
    }

}
