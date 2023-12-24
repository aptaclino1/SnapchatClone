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
    var users: [ChatUser] = []  // Assuming you have a list of ChatUser instances

    override func viewDidLoad() {
        super.viewDidLoad()

        // Assuming you have a list of ChatUser instances
        users = [
            ChatUser(senderId: "user1UID", displayName: "User 1"),
            ChatUser(senderId: "user2UID", displayName: "User 2"),
            // Add more users as needed
        ]
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of chats you want to display
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell

        let user = users[indexPath.row]
        cell.textLabel?.text = user.displayName
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedUser = users[indexPath.row]

        if let existingChatVC = navigationController?.viewControllers.first(where: { $0 is ChatVC && ( $0 as! ChatVC).user2UID == selectedUser.senderId }) as? ChatVC {
            // ChatVC instance already exists for the selected user
            navigationController?.popToViewController(existingChatVC, animated: true)
        } else {
            // ChatVC instance doesn't exist, create a new one
            let vc = ChatVC()
            vc.user2UID = selectedUser.senderId

            vc.fetchUserInfo(uid: selectedUser.senderId) { userData in
                vc.otherUser = userData
            }

            navigationController?.pushViewController(vc, animated: true)
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

            // Ensure the completion block is called on the main thread
            completion(userData)
        }
    }
}
