//
//  FirebaseMagicModels.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 22/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import Foundation

struct FirebaseMagicKeys {
    
    struct User {
        static let name = "name"
        static let lastName = "lastName"
        static let username = "username"
        static let description = "description"
        static let bio = "bio"
        static let password = "password"
        static let profileImage = "profileImage"
        static let profileImageUrl = "profileImageUrl"
        static let ordersCount = "ordersCount"
        static let cityName = "cityName"
        static let mobileNumber = "mobileNumber"
        static let emailAddress = "emailAddress"
        static let linkedin = "linkedin"
        static let facebook = "facebook"
    }
    
    struct Order {
        static let id = "id"
        static let ownerId = "ownerId"
        static let imageUrl = "imageUrl"
        static let productName = "productName"
        static let creationDate = "creationDate"
    }
    
}

struct CurrentUser {
    
    let uid: String
    let name: String
    let lastName : String
    let username: String
    let description : String
    let bio : String
    let profileImageUrl: String
    let ordersCount: UInt
    let cityName : String
    let mobileNumber : String
    let emailAddress : String
    let linkedin : String
    let facebook : String
    
    init(uid: String, dictionary: [String : Any]) {
        self.uid = uid
        self.name = dictionary[FirebaseMagicKeys.User.name] as? String ?? ""
        self.lastName = dictionary[FirebaseMagicKeys.User.lastName] as? String ?? ""
        self.username = dictionary[FirebaseMagicKeys.User.username] as? String ?? ""
        self.description = dictionary[FirebaseMagicKeys.User.description] as? String ?? ""
        self.bio = dictionary[FirebaseMagicKeys.User.bio] as? String ?? ""
        self.profileImageUrl = dictionary[FirebaseMagicKeys.User.profileImageUrl] as? String ?? ""
        self.ordersCount = dictionary[FirebaseMagicKeys.User.ordersCount] as? UInt ?? 0
        self.cityName = dictionary[FirebaseMagicKeys.User.cityName] as? String ?? ""
        self.mobileNumber = dictionary[FirebaseMagicKeys.User.mobileNumber] as? String ?? ""
        self.emailAddress = dictionary[FirebaseMagicKeys.User.emailAddress] as? String ?? ""
        self.linkedin = dictionary[FirebaseMagicKeys.User.linkedin] as? String ?? ""
        self.facebook = dictionary[FirebaseMagicKeys.User.facebook] as? String ?? ""
        
    }
}

struct Order {
    
    var id: String?
    
    let user: CurrentUser
    let imageUrl: String
    var productName: String
    let creationDate: Date
    
    init(user: CurrentUser, dictionary: [String : Any]) {
        self.user = user as CurrentUser
        self.imageUrl = dictionary[FirebaseMagicKeys.Order.imageUrl] as? String ?? ""
        self.productName = dictionary[FirebaseMagicKeys.Order.productName] as? String ?? ""
        
        let secondsSince1970 = dictionary[FirebaseMagicKeys.Order.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsSince1970)
    }
}
