//
//  FeedVc.swift
//  SnapchatClone
//
//  Created by Messiah on 11/9/23.
//


import UIKit
import Firebase
import SDWebImage

class FeedVc: UIViewController{


    @IBOutlet weak var feedTable: UITableView!

    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap: Snap?


    override func viewDidLoad() {
        super.viewDidLoad()

        feedTable.backgroundColor = .clear
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)

        getUserInfo()
        getSnapsFromFirebase()
    }

    func getSnapsFromFirebase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting snaps: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("Snapshot is nil.")
                return
            }

            self.snapArray.removeAll()

            for document in snapshot.documents {
                let documentData = document.data()
                let documentId = document.documentID
                if let username = documentData["snapOwner"] as? String,
                    let imageUrlArray = documentData["imageUrlArray"] as? [String],
                    let date = documentData["date"] as? Timestamp {

                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                        if difference >= 24 {
                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                            } 
                            
                        } else {
                          let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                           self.snapArray.append(snap)
                       }
                    
                     
                    }
               
                }
            }

            DispatchQueue.main.async {
                self.feedTable.reloadData()
            }
        }
    }

    func getUserInfo() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Current user email is nil.")
            return
        }

        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: currentUserEmail).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting user info: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("User info snapshot is nil.")
                return
            }

            for document in snapshot.documents {
                if let username = document.get("username") as? String {
                    UserSingleton.sharedUserInfo.email = currentUserEmail
                    UserSingleton.sharedUserInfo.username = username
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnap" {
            let vc = segue.destination as! SnapVC
            vc.selectedSnap = chosenSnap
            
            
        }
    }
}

extension FeedVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.backgroundColor = .clear
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.userImage.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
         return cell
     }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnap", sender: nil)
    }
}
