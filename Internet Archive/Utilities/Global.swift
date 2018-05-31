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
    
    static func saveFavoriteData(identifer: String) {
        var favorites = getFavoriteData()
        
        if  favorites == nil {
            UserDefaults.standard.set([identifer], forKey: "FavoriteData")
        } else {
            if !(favorites?.contains(identifer))! {
                favorites?.append(identifer)
                UserDefaults.standard.set(favorites, forKey: "FavoriteData")
            }
        }
    }
    
    static func getFavoriteData() -> [String]? {
        let ret = UserDefaults.standard.stringArray(forKey: "FavoriteData")
        return ret
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
    
    static func formatDate(string: String?) -> String? {
        if string == nil {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string!)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        return (date != nil) ?
            dateFormatterPrint.string(from: date!) : string
    }
}
