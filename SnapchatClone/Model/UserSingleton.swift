//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Burak Afyonlu on 12.03.2023.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
        
        
    }
    
}
