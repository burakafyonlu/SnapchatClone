//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Burak Afyonlu on 10.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FirebaseFirestore

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButton(_ sender: Any) {
        
        if passwordText.text != "" && emailText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            
            makeAlert(title:"Error", Message: "Password/Email ?")
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.emailText.text! , "username" : self.usernameText.text!] as [String : Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            
           makeAlert(title: "Error", Message: "Username/Password/Email ?")
            
        }
        
    }
    
    func makeAlert(title : String , Message : String) {
        
        let alert = UIAlertController(title: title , message: Message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
}





