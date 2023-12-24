//
//  ChatVC.swift
//  SnapchatClone
//
//  Created by Messiah on 11/14/23.
//

// ChatVC.swift

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage

class ChatVC: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    var currentUser: User?
    var user2Name: String?
    var user2ImgUrl: String?
    var user2UID: String?
    private var docReference: DocumentReference?
    var messages: [Message] = []
    var otherUser: [String: Any]? {
            didSet {
                // Update UI when otherUser is set
                updateUIWithOtherUserData()
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        } else {
            // Handle the case where the user is not authenticated
            print("Error: Current user is nil.")
            return
        }

        if let otherUserID = otherUser?["uid"] as? String {
                  fetchUserInfo(uid: otherUserID) { userData in
                      self.otherUser = userData
                  }
              }
          
    
        self.title = user2Name ?? "Chat"

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true

        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)

        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        loadChat()
    }
    private func updateUIWithOtherUserData() {
        // Update UI elements using otherUser data
        if let otherUsername = otherUser?["displayName"] as? String {
            self.title = otherUsername
        }

        // Optionally, update other UI elements based on otherUser data
    }
    // MARK: - Custom messages handlers

    func createNewChat() {
        if let currentUser = currentUser, let user2UID = user2UID {
            let users = [currentUser.uid, user2UID]
            let data: [String: Any] = ["users": users]

            let db = Firestore.firestore().collection("Chats")
            db.addDocument(data: data) { [weak self] (error) in
                guard let self = self else { return }
                if let error = error {
                    print("Unable to create chat! \(error)")
                    return
                } else {
                    self.loadChat()
                }
            }
        } else {
            print("Error: currentUser or user2UID is nil.")
        }
    }

    func loadChat() {
        guard let currentUser = currentUser, let user2UID = user2UID else {
            return
        }

       
        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: currentUser.uid)

        db.getDocuments { [weak self] (chatQuerySnap, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error: \(error)")
                return
            } else {
            
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }

                if queryCount == 0 {
                    
                    self.createNewChat()
                } else if queryCount >= 1 {
                  
                    for doc in chatQuerySnap!.documents {
                        if let chat = Chat(dictionary: doc.data()), chat.users.contains(user2UID) {

                            self.docReference = doc.reference

                         
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true) { [weak self] (threadQuery, error) in
                                    guard let self = self else { return }

                                    if let error = error {
                                        print("Error: \(error)")
                                        return
                                    }

                                    self.messages.removeAll()

                                    for messageDocument in threadQuery?.documents ?? [] {
                                        if let msg = Message(dictionary: messageDocument.data()) {
                                            self.messages.append(msg)
                                          
                                        }
                                    }

                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                            }

                           
                            let otherUserID = chat.users.first(where: { $0 != currentUser.uid }) ?? ""
                            print("Other user ID: \(otherUserID)")
                            self.fetchUserInfo(uid: otherUserID) { userData in
                             
                            }

                            return
                        }
                    }
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }

    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()

        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }

    private func save(_ message: Message) {
        guard let docReference = docReference else {
            print("Error: Document reference is nil.")
            return
        }

        guard !docReference.documentID.isEmpty else {
            print("Error: Document ID is empty.")
            return
        }

        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]

        docReference.collection("thread").addDocument(data: data) { [weak self] (error) in
            guard let self = self else { return }

            if let error = error {
                print("Error Sending message: \(error)")
                return
            }

            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }

    // MARK: - InputBarAccessoryViewDelegate

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let currentUser = currentUser else {
            print("Error: Current user is nil.")
            return
        }

        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUser.displayName ?? "")

        insertNewMessage(message)
        save(message)

        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }

    // MARK: - MessagesDataSource

    func currentSender() -> SenderType {
        guard let currentUser = currentUser else {
            return ChatUser(senderId: "default", displayName: "DefaultUser")
        }
        return ChatUser(senderId: currentUser.uid, displayName: currentUser.displayName ?? "")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    // MARK: - MessagesLayoutDelegate

    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    // MARK: - MessagesDisplayDelegate

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .cyan
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == currentUser?.uid {
            if let currentUserPhotoURL = currentUser?.photoURL {
                SDWebImageManager.shared.loadImage(with: currentUserPhotoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    avatarView.image = image
                }
            }
        } else {
            if let user2ImgUrl = user2ImgUrl, let user2ImgURL = URL(string: user2ImgUrl) {
                SDWebImageManager.shared.loadImage(with: user2ImgURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    avatarView.image = image
                }
            }
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
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


