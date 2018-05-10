//
//  LoginVC.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLogin(_ sender: Any) {
        if !validate() {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        APIManager.sharedManager.login(email: email, password: password) { (data) in
            if data == nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                Global.showAlert(title: "Error", message: "Server error", target: self)
                return
            }
            
            if data!["success"] as! Bool {
                APIManager.sharedManager.getAccountInfo(email: email, completion: { (data) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let values = data!["values"] as! [String: Any]
                    let username = values["screenname"] as! String
                    
                    Global.saveUserData(userData: [
                        "username" : username,
                        "email" : email,
                        "password" : password,
                        "logged-in" : true
                        ])
                    
                    let accountNC = self.navigationController as? AccountNC
                    accountNC?.gotoAccountVC()
                })
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                Global.showAlert(title: "Error", message: "Login failed", target: self)
            }
        }
    }
    
    func validate() -> Bool {
        if txtEmail.text!.isEmpty {
            Global.showAlert(title: "Error", message: "Please enter an email address", target: self)
            return false
        }
        
        if txtPassword.text!.isEmpty {
            Global.showAlert(title: "Error", message: "Please enter a password", target: self)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
