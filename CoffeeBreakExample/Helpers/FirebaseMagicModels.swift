//
//  FirebaseMagicModels.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 22/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import Foundation

let keyName = "name"
let keyUsername = "username"
let keyEmail = "email"
let keyPassword = "password"
let keyProfileImage = "profileImage"
let keyProfileImageUrl = "profileImageUrl"

let keyFollowersCount = "followersCount"
let keyFollowingCount = "nfollowingCount"
let keyPostsCount = "postsCount"

let keyId = "id"
let keyOwnerId = "ownerId"
let keyImageUrl = "imageUrl"
let keyCaption = "caption"
let keyCreationDate = "creationDate"

struct CurrentUser {
  
  let uid: String
  let name: String
  let username: String
  let profileImageUrl: String
  let email: String
  
  let followersCount: Int
  let followingCount: Int
  let postsCount: Int
  
  init(uid: String, dictionary: [String : Any]) {
    self.uid = uid
    self.name = dictionary[keyName] as? String ?? ""
    self.username = dictionary[keyUsername] as? String ?? ""
    self.profileImageUrl = dictionary[keyProfileImageUrl] as? String ?? ""
    self.email = dictionary[keyEmail] as? String ?? ""
    
    self.followersCount = dictionary[keyFollowersCount] as? Int ?? 0
    self.followingCount = dictionary[keyFollowingCount] as? Int ?? 0
    self.postsCount = dictionary[keyPostsCount] as? Int ?? 0
  }
}

struct Post {
  
  var id: String?
  
  let user: CurrentUser
  let imageUrl: String
  let caption: String
  let creationDate: Date
  
  init(user: CurrentUser, dictionary: [String : Any]) {
    self.user = user as CurrentUser
    self.imageUrl = dictionary[keyImageUrl] as? String ?? ""
    self.caption = dictionary[keyCaption] as? String ?? ""
    
    let secondsSince1970 = dictionary[keyCreationDate] as? Double ?? 0
    self.creationDate = Date(timeIntervalSince1970: secondsSince1970)
  }
  
}
