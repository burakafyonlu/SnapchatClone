//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Burak Afyonlu on 10.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseAnalytics
import FirebaseFirestore

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignIn", sender: nil)
        } catch {
            
        }
        
    }
    
}
