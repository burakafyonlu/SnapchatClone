//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Burak Afyonlu on 10.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FirebaseFirestore
import SDWebImage

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snaps]()
    var chosenSnap : Snaps?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getUserInfo()
        getSnapsFromFirebase()
        
    }
    
    func getSnapsFromFirebase() {
        
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                
                self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if difference >= 24 {
                                            
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { error in
                                            }
                                        } else {
                                            
                                            let Snaps = Snaps(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                            self.snapArray.append(Snaps)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshots, error in
            
            if error != nil {
                
                self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                
            } else {
            
                if snapshots != nil && snapshots?.isEmpty == false {
                    
                    for document in snapshots!.documents {
                        
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                        
                    }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as? SnapVC
            destinationVC?.selectedSnap = chosenSnap
           
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
        
    }
    
    func makeAlert(title : String , Message : String) {
        
        let alert = UIAlertController(title: title , message: Message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
  
    

}


