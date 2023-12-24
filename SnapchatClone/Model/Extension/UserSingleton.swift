//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Messiah on 11/12/23.
//

import Foundation



class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
        
    }
}
