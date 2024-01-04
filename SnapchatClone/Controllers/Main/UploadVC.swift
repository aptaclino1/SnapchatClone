//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Messiah on 11/9/23.
//

import UIKit
import Firebase



class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var customBttn: UIButton!
    @IBOutlet weak var uploadImage: UIImageView!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        uploadImage.backgroundColor = .clear
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
        
        uploadImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        uploadImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func uploadButton(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media_files")
        
        if let data = uploadImage.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            let documentID = document.documentID
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                            let additionalDictionary = ["imageUrlArray": imageUrlArray] as? [String : Any]
                                                
                                            fireStore.collection("Snaps").document(documentID).setData(additionalDictionary!, merge: true) { error in
                                                    if error == nil {
                                                        
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImage.image = UIImage(named: "upload1")
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        
                                        let snapDictionary = ["imageUrlArray": [imageUrl!], "snapOwner": UserSingleton.sharedUserInfo.username, "date": FieldValue.serverTimestamp()] as [String: Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImage.image = UIImage(named: "upload1")
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
                        
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
