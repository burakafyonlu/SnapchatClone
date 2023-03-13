//
//  UploadVC.swift
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

class UploadVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPicture))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func selectPicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    

  
    @IBAction func uploadButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metadata, error in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            // Firestore
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshots, error in
                                
                                if error != nil {
                                    
                                    self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                                } else {
                                    
                                    if snapshots?.isEmpty == false && snapshots != nil {
                                        
                                        for document in snapshots!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String : Any]
            
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                    if error == nil {
                                                        
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "select")
                                                        
                                                    }
                                                }
                                                
                                            }
                                                
                                            
                                        }
                                        
                                    } else {
                                        
                                        let snapDictionary = ["imageUrlArray": [imageUrl!] , "snapOwner": UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            
                                            if error != nil {
                                              
                                                self.makeAlert(title: "Error", Message: error?.localizedDescription ?? "Error")
                                                
                                            } else {
                                                
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "select")
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                           
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(title : String , Message : String) {
        
        let alert = UIAlertController(title: title , message: Message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
}
