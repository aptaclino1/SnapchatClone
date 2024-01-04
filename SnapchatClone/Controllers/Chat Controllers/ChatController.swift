//
//  ChatController.swift
//  SnapchatClone
//
//  Created by Messiah on 11/16/23.
//
import UIKit
import Firebase

class ChatController: UIViewController {

   
   @IBOutlet weak var chatTable: UITableView!
   var user2UID: String?
   

   override func viewDidLoad() {
       super.viewDidLoad()
       let backgroundImage = UIImageView(frame: self.view.bounds)
       backgroundImage.image = UIImage(named: "background")
       backgroundImage.contentMode = .scaleAspectFill
       self.view.addSubview(backgroundImage)
       self.view.sendSubviewToBack(backgroundImage)
       chatTable.backgroundColor = .clear
   }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return 1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = chatTable.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
       
       let otherUsername = "Viper"
       cell.textLabel?.text = otherUsername
       cell.accessoryType = .disclosureIndicator
       
       if let user2UID = user2UID {
           fetchUserInfo(uid: user2UID) { (userData: [String: Any]?) in
               if let username = userData?["displayName"] as? String {
                   DispatchQueue.main.async {
                       cell.textLabel?.text = username
                   }
               } else {
                   
                   DispatchQueue.main.async {
                       cell.textLabel?.text = " "
                   }
               }
           }
       } else {
          
           cell.textLabel?.text = "Chat"
           cell.textLabel?.font = UIFont(name: "Avenir-BlackOblique", size: 25)
           cell.textLabel?.textColor = .gray
           
       }
       cell.backgroundColor = .yellow
       return cell
   }
   
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)

       
       let vc = ChatVC()
       vc.user2UID = "w3I1z2awS6S9aLP8zPG4ZaZN4kg2"

       guard let user2UID = vc.user2UID else {
           print("Error: user2UID is nil.")
           return
       }

       vc.fetchUserInfo(uid: user2UID) { userData in
           if let username = userData?["displayName"] as? String {
               vc.user2Name = username
           }

           // Ensure to update the UI on the main thread
           DispatchQueue.main.async {
               self.navigationController?.pushViewController(vc, animated: true)
           }
       }
   }

   func fetchUserInfo(uid: String, completion: @escaping ([String: Any]?) -> Void) {
       let userRef = Firestore.firestore().collection("UserInfo").document(uid)
       
       userRef.getDocument { (snapshot, error) in
           if let error = error {
               print("Error fetching user info: \(error.localizedDescription)")
               completion(nil)
               return
           }
           
           guard let snapshot = snapshot, snapshot.exists else {
               print("Snapshot does not exist or is nil for UID: \(uid)")
               completion(nil)
               return
           }
           
           let userData = snapshot.data() ?? [:]
           
          
           completion(userData)
       }
   }
}
