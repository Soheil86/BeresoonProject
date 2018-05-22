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
let keyNumberOfFollowers = "numberOfFollowers"
let keyNumberOfFollowing = "numberOfFollowing"
let keyNumberOfPosts = "numberOfPosts"

let keyThumbnailUrl = "thumbnailUrl"
let keyImageUrl = "imageUrl"
let keyCaption = "caption"
let keyCreationDate = "creationDate"
let keyOwnerId = "ownerId"

struct CurrentUser {
  
  let uid: String
  let name: String
  let username: String
  let profileImageUrl: String
  let numberOfFollowers: Int
  let numberOfFollowing: Int
  let numberOfPosts: Int
  let email: String
  
  init(uid: String, dictionary: [String : Any]) {
    self.uid = uid
    self.name = dictionary[keyName] as? String ?? ""
    self.username = dictionary[keyUsername] as? String ?? ""
    self.profileImageUrl = dictionary[keyProfileImageUrl] as? String ?? ""
    self.numberOfFollowers = dictionary[keyNumberOfFollowers] as? Int ?? 0
    self.numberOfFollowing = dictionary[keyNumberOfFollowing] as? Int ?? 0
    self.numberOfPosts = dictionary[keyNumberOfPosts] as? Int ?? 0
    self.email = dictionary[keyEmail] as? String ?? ""
  }
}

struct Post {
  
  var id: String?
  
  let user: CurrentUser
  let thumbnailUrl: String
  let imageUrl: String
  let caption: String
  let creationDate: Date
  var ownerId: String
  
  var hasLiked = false
  
  init(user: CurrentUser, dictionary: [String : Any]) {
    self.user = user as CurrentUser
    self.thumbnailUrl = dictionary[keyThumbnailUrl] as? String ?? ""
    self.imageUrl = dictionary[keyImageUrl] as? String ?? ""
    self.caption = dictionary[keyCaption] as? String ?? ""
    self.ownerId = dictionary[keyOwnerId] as? String ?? ""
    
    let secondsSince1970 = dictionary[keyCreationDate] as? Double ?? 0
    self.creationDate = Date(timeIntervalSince1970: secondsSince1970)
  }
  
}
