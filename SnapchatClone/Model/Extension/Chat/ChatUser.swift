//
//  ChatUser.swift
//  SnapchatClone
//
//  Created by Messiah on 11/15/23.
//

import Foundation
import MessageKit
import Firebase

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}

