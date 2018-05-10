//
//  Global.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import Foundation
import UIKit

class Global: NSObject {
    // Save UserData
    static func saveUserData(userData: [String: Any?]) {
        UserDefaults.standard.set(userData, forKey: "UserData")
    }
    
    // Get UserData
    static func getUserData() -> [String: Any?]? {
        return UserDefaults.standard.value(forKey: "UserData") as? [String : Any?]
    }
    
    static func isLoggedIn() -> Bool {
        if let userData = self.getUserData(),
            let isLoggedin = userData["logged-in"] as? Bool,
            isLoggedin == true {
            return true
        }
        return false
    }
    
    // Show Alert
    static func showAlert(title: String, message: String, target: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) {action in
            
        })
        target.present(alertController, animated: true)
    }
}
