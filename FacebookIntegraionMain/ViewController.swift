//
//  ViewController.swift
//  FacebookIntegraionMain
//
//  Created by R Shantha Kumar on 1/21/20.
//  Copyright © 2020 R Shantha Kumar. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loginManagerDidComplete(_ result:LoginResult){
        
        
        switch result {
        case .cancelled:
            
            print("login cancelled ")
            
        case .failed(let error):
            
            print("login failed")
            
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            
            var target = storyboard?.instantiateViewController(identifier: "Facebook") as! FacebookProfileViewController
       
           present(target, animated: true, completion: nil)
            
            
            
            
        }
        
    }

    
    
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        
  let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile,.userFriends], viewController: self) { (result) in
            
            self.loginManagerDidComplete(result)
        }
        
       
        
    }
    

}

