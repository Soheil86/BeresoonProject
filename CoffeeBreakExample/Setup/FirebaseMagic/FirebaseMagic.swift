//
//  FirebaseMagic.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//
// Icons from https://icons8.com/

import UIKit
import Firebase
import JGProgressHUD


class FirebaseMagic {
  
  // MARK: -
  // MARK: Firebase Database paths
  static let Database_Users = Database.database().reference().child(environment.rawValue).child("users")
  static let Database_Orders = Database.database().reference().child(environment.rawValue).child("orders")
  static let Database_UserOrders = Database.database().reference().child(environment.rawValue).child("userOrders")
  static let Database_UserTravel = Database.database().reference().child(environment.rawValue).child("userTravel")
  static let Database_UserFollowers = Database.database().reference().child(environment.rawValue).child("userFollowers")
  static let Database_UserFollowing = Database.database().reference().child(environment.rawValue).child("userFollowing")
  
  // MARK: -
  // MARK: Firebase Storage paths
  static let Storage_ProfileImages = Storage.storage().reference().child(environment.rawValue).child("profile_images")
  static let Storage_OrderImages = Storage.storage().reference().child(environment.rawValue).child("order_images")
  
  // MARK: -
  // MARK: Fetched containers
  static var fetchedOrders = [Order]()
  static var fetchedOrdersCurrentKey: String?
  static let paginationElementsLimitOrders: UInt = FirebaseMagicSetup.paginationElementsLimitOrders
  
  static var fetchedUserOrders = [Order]()
  static var fetchedUserOrdersCurrentKey: String?
  static let paginationElementsLimitUserOrders: UInt = FirebaseMagicSetup.paginationElementsLimitUserOrders
  
  static var fetchedFollowerUsers = [CurrentUser]()
  static var fetchedFollowerUsersCurrentKey: String?
  static let paginationElementsLimitFollowerUsers: UInt = FirebaseMagicSetup.paginationElementsLimitFollowerUsers
  
  static var fetchedFollowingUsers = [CurrentUser]()
  static var fetchedFollowingUsersCurrentKey: String?
  static let paginationElementsLimitFollowingUsers: UInt = FirebaseMagicSetup.paginationElementsLimitFollowingUsers
  
  // MARK: -
  // MARK: Enums
  enum OrderFetchType: Int {
    case onHome = 0
    case onUserProfile = 1
  }
  
  enum StatFetchType: Int {
    case followers = 0
    case following = 1
  }
  
  enum Environment: String {
    case development = "development"
    case production = "production"
    case none = "none"
  }
  
  // MARK: -
  // MARK: Miscellaneous
  static var environment: Environment = .none
  static var currentlyFetchingOrders = false
  static var searchUsersFetchLimit = 10
  fileprivate static var currentUserId: String? = nil

  // MARK: -
  // MARK: Start
  static func start() {
    #if DEVELOPMENT
    self.environment = .development
    #else
    self.environment = .production
    #endif
    print("Started FirebaseMagic in environment: \(environment)")
    FirebaseApp.configure()
    
    
    
    Auth.auth().addStateDidChangeListener { auth, user in
      if let user = user {
        // User is signed in.
        currentUserId = user.uid
      } else {
        // No user is signed in.
        currentUserId = nil
      }
    }
  }
  
  // MARK: -
  // MARK: Check for Start
  fileprivate static func hasFirebaseMagicBeenStarted() -> Bool {
    if environment == .none {
      print("FirebaseMagic configuration error. Please use 'FirebaseMagic.start()' in your AppDelegate's 'application(_ didFinishLaunchingWithOptions)' function.")
      return false
    } else {
      return true
    }
  }
  
  // MARK: -
  // MARK: Current user uid
  static func currentUserUid() -> String? {
    if !hasFirebaseMagicBeenStarted() { return nil }
//    return Auth.auth().currentUser?.uid // old way
    return currentUserId
  }
  
  // MARK: -
  // MARK: Check signed in user
  static func checkIfUserIsSignedIn(completion: @escaping (_ result: Bool) ->()) {
    if !hasFirebaseMagicBeenStarted() { return }
    if Auth.auth().currentUser == nil {
      completion(false)
    } else {
      completion(true)
    }
  }
  
  // MARK: -
  // MARK: Logout
  static func logout(completion: @escaping (_ error: Error?) ->()) {
    if !hasFirebaseMagicBeenStarted() { return }
    do {
      try Auth.auth().signOut()
      completion(nil)
    } catch let err {
      print("Failed to sign out with error:", err)
      completion(err)
    }
  }
  
  // MARK: -
  // MARK: Reset password
  static func resetPassword(withUsernameOrEmail usernameOrEmail: String?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    if !hasFirebaseMagicBeenStarted() { return }
    guard let usernameOrEmail = usernameOrEmail else {
      completion(false, nil)
      return
    }
    
    if usernameOrEmail.range(of: "@") != nil {
      print("Reseting password with email:", usernameOrEmail)
      resetPassword(withEmail: usernameOrEmail) { (result, err) in
        completion(result, err)
      }
      
    } else {
      print("Reseting password with username:", usernameOrEmail)
      resetPassword(withUserName: usernameOrEmail) { (result, err) in
        completion(result, err)
      }
    }
  }
  
  fileprivate static func resetPassword(withUserName username: String, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    
    fetchUsers(withUsername: username, limitedToFirst: 1) { (users, err) in
      if let err = err {
        print("Failed to reset password with email:", err)
        completion(false, err)
        return
      }
      
      guard let user = users?.first else {
        print("Failed to reset password with email: no such user with username '\(username)'")
        completion(false, nil)
        return
      }
      
      resetPassword(withEmail: user.emailAddress) { (result, err) in
        completion(result, err)
      }
      
    }
  }
  
  fileprivate static func resetPassword(withEmail email: String, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    Auth.auth().sendPasswordReset(withEmail: email) { (err) in
      if let err = err {
        print("Failed to reset password with email:", err)
        completion(false, err)
        return
      }
      print("Successfully sent reset password to email:", email)
      completion(true, nil)
    }
  }
  
  // MARK: -
  // MARK: Sign in
  static func signIn(withUsernameOrEmail usernameOrEmail: String?, password: String?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    if !hasFirebaseMagicBeenStarted() { return }
    guard let usernameOrEmail = usernameOrEmail, let password = password else {
      completion(false, nil)
      return
    }
    
    if usernameOrEmail.range(of: "@") != nil {
      print("Signing in with email:", usernameOrEmail)
      signIn(withEmail: usernameOrEmail, password: password) { (result, err) in
        completion(result, err)
      }
      
    } else {
      print("Signing in with username:", usernameOrEmail)
      signIn(withUsername: usernameOrEmail, password: password) { (result, err) in
        completion(result, err)
      }
    }
    
  }
  
  fileprivate static func signIn(withUsername username: String, password: String, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    
    fetchUsers(withUsername: username, limitedToFirst: 1) { (users, err) in
      if let err = err {
        print("Failed to sign in:", err)
        completion(false, err)
        return
      }
      
      guard let user = users?.first else {
        print("Failed to sign in: no such user with username '\(username)'")
        completion(false, nil)
        return
      }
      
      signIn(withEmail: user.emailAddress, password: password) { (result, err) in
        completion(result, err)
      }
    }
  }
  
  fileprivate static func signIn(withEmail email: String, password: String, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
      if let err = err {
        print("Failed to sign in with email:", err)
        completion(false, err)
        return
      }
      
      guard let result = result else {
        completion(false, nil)
        return
      }
      print("Successfully logged back in with user:", result.user.uid)
      completion(true, nil)
    }
  }
  
  // MARK: -
  // MARK: Sign up
  fileprivate static func checkUsernameAvailability(for username: String, userCredentials: [String : Any], completion: @escaping (_ result: Bool,_ userCredentials: [String : Any], _ error: Error?) ->()) {
    fetchUsers(withUsername: username, limitedToFirst: 1, isOnSignup: true) { (users, err) in
      if let err = err {
        completion(false, userCredentials, err)
      }
      
      if users == nil {
        completion(true, userCredentials, nil)
        return
      } else {
        
        let textField = UITextField()
        textField.placeholder = "New Username"
        textField.autocapitalizationType = .none
        
        FirebaseMagicService.showAlert(style: .alert, title: "Sign Up Error", message: "The username '\(username.lowercased())' is already taken. Please, choose another one.", textFields: [textField], completion: { (usernames) in
          guard let usernames = usernames, let username = usernames.first else {
            completion(false, userCredentials, nil)
            return
          }
          
          var mutableUserCredentials = userCredentials
          mutableUserCredentials.updateValue(username, forKey: FirebaseMagicKeys.User.username)
          
          checkUsernameAvailability(for: username, userCredentials: mutableUserCredentials, completion: { (result, userCredentials, err) in
            completion(result, userCredentials, err)
          })
          
        })
        
      }
    }
  }
  
  static func signUpUserWithEmail(userCredentials: [String : Any], userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    if !hasFirebaseMagicBeenStarted() { return }
    guard let username = userCredentials[FirebaseMagicKeys.User.username] as? String else {
      completion(false, nil)
      return
    }
    
    checkUsernameAvailability(for: username, userCredentials: userCredentials) { (result, userCredentials, err) in
      if let err = err {
        completion(false, err)
      }
      
      if result {
        signUpUniqueUserWithEmail(userCredentials: userCredentials, userDetails: userDetails) { (result, err) in
          completion(result, err)
        }
      } else {
        completion(false, nil)
      }
      
    }
    
  }
  
  fileprivate static func signUpUniqueUserWithEmail(userCredentials: [String : Any], userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let email = userCredentials[FirebaseMagicKeys.User.emailAddress] as? String,
      let password = userCredentials[FirebaseMagicKeys.User.password] as? String else {
        completion(false, nil)
        return
    }
    
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
      if let err = err {
        print("Failed to create Firebase user:", err)
        completion(false, err)
        return
      }
      
      guard let result = result else {
        completion(false, nil)
        return
      }
      print("Successfully created Firebase user:", result.user.uid )
      saveUserIntoFirebase(user: result.user, userCredentials: userCredentials, userDetails: userDetails, completion: { (result, err) in
        if let err = err {
          completion(false, err)
          return
        } else if result == false {
          completion(false, nil)
          return
        }
        completion(result, err)
      })
    }
  }
  
  // MARK: -
  // MARK: Save user into Firebase
  fileprivate static func saveUserIntoFirebase(user: User?, userCredentials: [String : Any], userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let user = user,
      let email = user.email,
      let username = userCredentials[FirebaseMagicKeys.User.username] as? String else {
      completion(false, nil)
      return
    }
    
    let uid = user.uid
    var mutableUserDetails: [String : Any] = [FirebaseMagicKeys.User.username: username.firebaseKeyCompatible(), FirebaseMagicKeys.User.emailAddress : email.lowercased()]
    
    if let userDetails = userDetails {
      mutableUserDetails.update(with: userDetails)
      
      if let profileImage = mutableUserDetails[FirebaseMagicKeys.User.profileImage] as? UIImage {
        saveImage(profileImage, atPath: Storage_ProfileImages) { (imageUrl, result, err) in
          if let err = err {
            completion(false, err)
            return
          } else if result == false {
            completion(false, nil)
            return
          }
          guard let imageUrl = imageUrl else {
            completion(false, nil)
            return
          }
          
          mutableUserDetails.updateValue(imageUrl, forKey: FirebaseMagicKeys.User.profileImageUrl)
          mutableUserDetails.removeValue(forKey: FirebaseMagicKeys.User.profileImage)
          
          updateUserValues(forCurrentUserUid: uid, with: mutableUserDetails, username: username, email: email) { (result, err) in
            completion(result, err)
          }
          
        }
      } else {
        
        updateUserValues(forCurrentUserUid: uid, with: mutableUserDetails, username: username, email: email) { (result, err) in
          completion(result, err)
        }
        
      }
    } else {
      
      updateUserValues(forCurrentUserUid: uid, with: mutableUserDetails, username: username, email: email) { (result, err) in
        completion(result, err)
      }
      
    }
    
  }
  
  // MARK: -
  // MARK: Firebase Actions
   fileprivate static func updateUserValues(forCurrentUserUid currentUserUid: String, with dictionary: [String : Any], username: String, email: String,  completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    
    updateValues(atPath: Database_Users.child(currentUserUid), with: dictionary, completion: { (result, err) in
      if let err = err {
        completion(false, err)
        return
      } else if result == false {
        completion(false, nil)
        return
      }
        
      let values = [currentUserUid : 1]
      updateValues(atPath: Database_UserFollowers.child(currentUserUid), with: values, completion: { (result, err) in
        completion(result, err)
      })
    })
  }
    
    static func updateUser(forCurrentUserUid currentUserUid: String, with dictionary: [String : Any],  completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
        
        updateValues(atPath: Database_Users.child(currentUserUid), with: dictionary, completion: { (result, err) in
            if let err = err {
                completion(false, err)
                return
            } else if result == false {
                completion(false, nil)
                return
            }
            
            let values = [currentUserUid : 1]
            updateValues(atPath: Database_UserFollowers.child(currentUserUid), with: values, completion: { (result, err) in
                completion(result, err)
            })
        })
    }
  
  fileprivate static func updateValues(atPath path: DatabaseReference, with dictionary: [String : Any],  completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    path.updateChildValues(dictionary) { (err, ref) in
      if let err = err {
        print("Failed to update Firebase database with error:", err)
        completion(false, err)
        return
      }
      print("Successfully updated Firebase database at path: '\(path)' with values: '\(dictionary)'")
      completion(true, nil)
    }
  }
  
  fileprivate static func observeValues(atPath path: DatabaseReference, eventType: DataEventType,  completion: @escaping (_ snapshot: DataSnapshot?, _ error: Error?) ->()) {
    path.observe(eventType, with: { (snapshot) in
      completion(snapshot, nil)
    }) { (err) in
      completion(nil, err)
    }
  }
  
  fileprivate static func saveImage(_ image: UIImage, atPath path: StorageReference, completion: @escaping (_ imageUrl: String?, _ result: Bool, _ error: Error?) ->()) {
    guard let imageUploadData = UIImageJPEGRepresentation(image, 0.3) else {
      completion(nil, false, nil)
      return
    }
    let fileName = UUID().uuidString
    path.child(fileName).putData(imageUploadData, metadata: nil) { (metadata, err) in
      if let err = err {
        print("Failed to upload image into Firebase storage with error:", err)
        completion(nil, false, err)
        return
      }
      path.child(fileName).downloadURL(completion: { (url, err) in
        if let err = err {
          print("Failed to get image url with error:", err)
          completion(nil, false, err)
          return
        }
        guard let imageUrl = url?.absoluteString else {
          completion(nil, false, nil)
          return
        }
        print("Successfully uploaded image into Firebase storage with URL:", imageUrl)
        completion(imageUrl, true, nil)
      })
    }
  }
  
  // MARK: -
  // MARK: Fetch users
  static func fetchUsers(withUsername username: String, limitedToFirst: Int, isOnSignup: Bool? = false, completion: @escaping (_ users: [CurrentUser]?, _ error: Error?) -> ()) {
    if !hasFirebaseMagicBeenStarted() { return }
    var filteredUsers: [CurrentUser] = []
    let allowedUsername = username.firebaseKeyCompatible()
    var userRef = Database_Users.queryLimited(toFirst: UInt(limitedToFirst)).queryOrdered(byChild: FirebaseMagicKeys.User.username).queryStarting(atValue: allowedUsername).queryEnding(atValue: allowedUsername+"\u{f8ff}")
    
    if limitedToFirst == 1 {
      userRef = Database_Users.queryLimited(toFirst: UInt(limitedToFirst)).queryOrdered(byChild: FirebaseMagicKeys.User.username).queryEqual(toValue: allowedUsername)
    }
    
    userRef.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if snapshot.exists() {
        guard let dictionaries = snapshot.value as? [String: Any] else {
          completion(nil, nil)
          return
        }
        
        dictionaries.forEach({ (key, value) in
          if key == currentUserUid() {
            completion(nil, nil)
            return
          }
          guard let userDictionary = value as? [String: Any] else {
            completion(nil, nil)
            return
          }
          
          var mutableDictionary = userDictionary
          getUserStats(forUid: key, completion: { (userStats, err) in
            
            if let err = err {
              print("Failed to fetch user stats:", err)
              completion(nil, err)
              return
            }
            if let userStats = userStats {
              mutableDictionary.update(with: userStats)
              let user = CurrentUser(uid: key, dictionary: mutableDictionary)
              let isContained = filteredUsers.contains(where: { (containedUser) -> Bool in
                return user.uid == containedUser.uid
              })
              if !isContained {
                filteredUsers.append(user)
              }
              print("Filtered users:", filteredUsers)
              completion(filteredUsers, nil)
            } else {
              print("Failed to fetch user stats.")
              completion(nil, nil)
            }
            
          })
          
        })
      } else {
        print("No users available for requested username:", allowedUsername)
        if limitedToFirst == 1 {
          if isOnSignup == false {
            FirebaseMagicService.showAlert(style: .alert, title: "Info", message: "No users available for requested username: \(allowedUsername)")
          }
          
        }
        completion(nil, nil)
      }
      
    }) { (err) in
      print("Failed to fetch users:", err)
      completion(nil, err)
    }
  }
  
  static func fetchUser(withUid uid: String, completion: @escaping (_ user: CurrentUser?, _ error: Error?) -> ()) {
    Database_Users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      if !hasFirebaseMagicBeenStarted() { return }
      guard let dictionary = snapshot.value as? [String : Any] else {
        completion(nil, nil)
        return
      }
      var mutableDictionary = dictionary
        
     // getUserStats(forUid: uid, completion: { (userStats, err) in
//        if let err = err {
//          print("Failed to fetch user stats:", err)
//          completion(nil, err)
//          return
//        }
//        if let userStats = userStats {
//          mutableDictionary.update(with: userStats)
          let user = CurrentUser(uid: uid, dictionary: mutableDictionary)
          completion(user, nil)
          return
        //}
//        else {
//          print("Failed to fetch user stats.")
//          completion(nil, nil)
//        }
    
      })
//
//    }) { (err) in
//      print("Failed to fetch user:", err)
//      completion(nil, err)
//    }
  }
  
  fileprivate static func getUserStats(forUid uid: String, completion: @escaping (_ userStatsDictionary: [String : Any]?, _ error: Error?) -> ()) {
    var userStats: [String : Any] = [:]
    Database_UserOrders.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      let ordersCount = snapshot.childrenCount
      userStats.update(with: [FirebaseMagicKeys.User.ordersCount: ordersCount])
      
      Database_UserFollowers.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        let followersCount = snapshot.childrenCount
        // remove self from followers count
        var rectifiedFollowersCount = Int(followersCount) - 1
        // make sure we do not get a negative followers count
        if rectifiedFollowersCount <= 0 {
          rectifiedFollowersCount = 0
        }
//        userStats.update(with: [FirebaseMagicKeys.User.followersCount: UInt(rectifiedFollowersCount)])
        
        Database_UserFollowing.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
          let followingCount = snapshot.childrenCount
          var rectifiedFollowingCount = Int(followingCount)
          // make sure we do not get a negative following count
          if rectifiedFollowingCount <= 0 {
            rectifiedFollowingCount = 0
          }
//          userStats.update(with: [FirebaseMagicKeys.User.followingCount: UInt(rectifiedFollowingCount)])
//          completion(userStats, nil)
          
        }, withCancel: { (err) in
          print("Failed to fetch user following for count:", err)
          completion(nil, err)
        })
        
      }, withCancel: { (err) in
        print("Failed to fetch user followers for count:", err)
        completion(nil, err)
      })
      
    }, withCancel:{ (err) in
      print("Failed to fetch user orders for count:", err)
      completion(nil, err)
    })
  }
  
  // MARK: -
  // MARK: Share order
  static func shareOrder(withProductName productName: String, image: UIImage, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    if !hasFirebaseMagicBeenStarted() { return }
    saveImage(image, atPath: Storage_OrderImages) { (imageUrl, result, err) in
      if let err = err {
        completion(false, err)
        return
      } else if result == false {
        completion(false, nil)
        return
      }
      guard let imageUrl = imageUrl, let currentUserUid = currentUserUid() else {
        completion(false, nil)
        return
      }
      let orderRef = Database_Orders.childByAutoId()
      let orderId = orderRef.key
      let values = [FirebaseMagicKeys.Order.productName: productName,
                    FirebaseMagicKeys.Order.imageUrl: imageUrl,
                    FirebaseMagicKeys.Order.ownerId: currentUserUid,
                    FirebaseMagicKeys.Order.id: orderId,
                    FirebaseMagicKeys.Order.creationDate : Date().timeIntervalSince1970] as [String : Any]
      
      updateValues(atPath: orderRef, with: values, completion: { (result, err) in
        if let err = err {
          completion(false, err)
          return
        } else if result == false {
          completion(false, nil)
          return
        }
        
        let values = [orderId : 1]
        updateValues(atPath: Database_UserOrders.child(currentUserUid), with: values, completion: { (result, err) in
          if let err = err {
            completion(false, err)
            return
          } else if result == false {
            completion(false, nil)
            return
          }
          
          observeValues(atPath: Database_UserFollowers.child(currentUserUid), eventType: .value, completion: { (snapshot, err) in
            if let err = err {
              completion(false, err)
              return
            } else if snapshot == nil {
              completion(false, nil)
              return
            }
            guard let snapshot = snapshot else {
              completion(false, nil)
              return
            }
            var followersCount = snapshot.childrenCount
            
            observeValues(atPath: Database_UserFollowers.child(currentUserUid), eventType: .childAdded, completion: { (snapshot, err) in
              if let err = err {
                completion(false, err)
                return
              } else if snapshot == nil {
                completion(false, nil)
                return
              }
              guard let snapshot = snapshot else {
                completion(false, nil)
                return
              }
              
              let followerUid = snapshot.key
              let values = [orderId : 1]
              updateValues(atPath: Database_UserTravel.child(followerUid), with: values, completion: { (result, err) in
                followersCount -= 1
                if followersCount == 0 {
                  print("Updated all follower's user feed.")
                  completion(result, err)
                } else {
                  print("Updated another follower's user feed. \(followersCount) left.")
                }
              })
            })
          })
        })
      })
    }
  }
  
  // MARK: -
  // MARK: Fetch user orders
  static func fetchUserOrders(forUid uid: String?, fetchType: OrderFetchType, in collectionViewController: UICollectionViewController, completion: @escaping (_ result: Bool, _ error: Error?) -> ()) {
    if !hasFirebaseMagicBeenStarted() { return }
    
    collectionViewController.collectionView?.backgroundView?.alpha = 0.0
    if currentlyFetchingOrders {
        completion(false, nil)
        return
    }
    currentlyFetchingOrders = true
    
    guard let uid = uid else {
        currentlyFetchingOrders = false
        completion(false, nil)
        return
    }
    print("Started fetching (\(fetchType)) posts for current user with id:", uid)
    
    if  (fetchType == .onHome ? fetchedOrdersCurrentKey : fetchedUserOrdersCurrentKey) == nil {
        // initial pull
        let ref = Database_Orders
        let uid = "-LmPE1xIHYjRNZRxTxKK"
        ref.child(uid).queryLimited(toLast: fetchType == .onHome ? paginationElementsLimitOrders : paginationElementsLimitUserOrders).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                print("No posts to fetch for user.")
                currentlyFetchingOrders = false
                collectionViewController.collectionView?.backgroundView?.alpha = 1.0
                collectionViewController.collectionView?.reloadData()
                completion(false, nil)
            }
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot], let first = snapshot.children.allObjects.first as? DataSnapshot else {
                currentlyFetchingOrders = false
                completion(false, nil)
                return
            }
            
            allObjects.forEach({ (snapshot) in
                let orderId = snapshot.key
                fetchUserOrder(withOrderId: orderId, fetchType: fetchType, in: collectionViewController, completion: { (result, err) in
                    if let err = err {
                        currentlyFetchingOrders = false
                        completion(result, err)
                    } else if result == false {
                        currentlyFetchingOrders = false
                        completion(result, err)
                    }
                    // not completing when (true, nil) because of pagination
                })
            })
            
            if fetchType == .onHome {
                fetchedOrdersCurrentKey = first.key
            } else {
                fetchedOrdersCurrentKey = first.key
            }
            
            currentlyFetchingOrders = false
            completion(true, nil)
        }) { (err) in
            print("Failed to query current user posts: ", err)
            currentlyFetchingOrders = false
            completion(false, err)
        }
        
    } else {
        // paginate here
        let ref =  Database_Orders
        ref.child(uid).queryOrderedByKey().queryEnding(atValue: fetchType == .onHome ? fetchedOrdersCurrentKey : fetchedUserOrdersCurrentKey).queryLimited(toLast: fetchType == .onHome ? paginationElementsLimitOrders : paginationElementsLimitUserOrders).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                print("No posts to fetch for user.")
                currentlyFetchingOrders = false
                completion(false, nil)
            }
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot], let first = snapshot.children.allObjects.first as? DataSnapshot else {
                currentlyFetchingOrders = false
                completion(false, nil)
                return
            }
            
            allObjects.forEach({ (snapshot) in
                
                if snapshot.key != (fetchType == .onHome ? fetchedOrdersCurrentKey : fetchedUserOrdersCurrentKey) {
                    let orderId = snapshot.key
                    fetchUserOrder(withOrderId: orderId, fetchType: fetchType, in: collectionViewController, completion: { (result, err) in
                        if let err = err {
                            currentlyFetchingOrders = false
                            completion(result, err)
                        } else if result == false {
                            currentlyFetchingOrders = false
                            completion(result, err)
                        }
                        // not completing when (true, nil) because of pagination
                    })
                }
                
            })
            
            if fetchType == .onHome {
                fetchedOrdersCurrentKey = first.key
            } else {
                fetchedUserOrdersCurrentKey = first.key
            }
            
            currentlyFetchingOrders = false
            completion(true, nil)
        }) { (err) in
            print("Failed to query and paginate current user: ", err)
            currentlyFetchingOrders = false
            completion(false, err)
        }
    }
    
    }
  fileprivate static func fetchUserOrder(withOrderId orderId: String, fetchType: OrderFetchType, in collectionViewController: UICollectionViewController, completion: @escaping (_ result: Bool, _ error: Error?) -> ()) {
    
    fetchOrder(withOrderId: orderId) { (order, err) in
      if let err = err {
        completion(false, err)
        return
      }
      guard let order = order else {
        completion(false, nil)
        return
      }
      
      switch fetchType {
      case .onHome:
        fetchedOrders.insert(order, at: 0)
        self.fetchedOrders.sort(by: { (p1, p2) -> Bool in
          return p1.creationDate.compare(p2.creationDate) == .orderedDescending
        })
      case .onUserProfile:
        fetchedUserOrders.insert(order, at: 0)
        self.fetchedUserOrders.sort(by: { (p1, p2) -> Bool in
          return p1.creationDate.compare(p2.creationDate) == .orderedDescending
        })
      }
      
      collectionViewController.collectionView?.reloadData()
      print("Fetched current user order with id:", orderId)
      
      completion(true, nil)
    }
  }
  
  fileprivate static func fetchOrder(withOrderId orderId: String, completion: @escaping(_ order: Order?, _ error: Error?) -> ()) {
    
   let orderId = "-LmPE1xIHYjRNZRxTxKK"
    Database_Orders.child(orderId).observeSingleEvent(of: .value) { (snapshot) in
      guard let dictionary = snapshot.value as? Dictionary<String, AnyObject>, let ownerUid = dictionary[FirebaseMagicKeys.Order.ownerId] as? String else {
        completion(nil, nil)
        return
      }

      fetchUser(withUid: ownerUid, completion: { (user, err) in
        if let err = err {
          completion(nil, err)
        }
        
        guard let user = user else {
          completion(nil, nil)
          return
        }
        var order = Order(user: user, dictionary: dictionary)
        order.id = orderId
        completion(order, nil)
      })
    }
  }
  
  // MARK: -
  // MARK: Follow / unfollow
  static func isCurrentUserFollowing(userId: String, completion: @escaping (Bool?) -> ()) {
    if !hasFirebaseMagicBeenStarted() { return }
    guard let currentLoggedInUserId = currentUserUid() else { completion(nil); return }
    Database_UserFollowing.child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
      if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
        // is already following user
        completion(true)
      } else {
        // not following user
        completion(false)
      }
    }, withCancel: { (err) in
      print("Failed to fetch followed users with error:", err)
      //Service.showErrorAlert(on: self, title: "Fetch Error", message: err.localizedDescription)
      completion(nil)
    })
  }
  
  static func handleFollowButton(followingUserId: String, followedUserId: String, completion: @escaping (_ result: Bool, _ error: Error?) -> ()) {
    if !hasFirebaseMagicBeenStarted() { return }
    let values = [followedUserId: 1]
    Database_UserFollowing.child(followingUserId).updateChildValues(values) { (err, ref) in
      if let err = err {
        print("Failed to follow user with err:", err)
        completion(false, err)
        return
      }
      print("Successfully followed user with id:", followedUserId)
      
      let values = [followingUserId: 1]
      Database_UserFollowers.child(followedUserId).updateChildValues(values, withCompletionBlock: { (err, ref) in
        if let err = err {
          print("Failed to follow user with err:", err)
          completion(false, err)
          return
        }
        print("Successfully saved new follower id:", followingUserId)
        
        // add followed user order into current user feed
        Database_UserOrders.child(followedUserId).observe(.childAdded, with: { (snapshot) in
          let orderId = snapshot.key
          let values = [orderId: 1]
          Database_UserTravel.child(followingUserId).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
              print("Failed to add followed user order into current user Travel with error:", err)
              completion(false, err)
              return
            }
          })
        }, withCancel: { (err) in
          print("Failed to observe followed with error:", err)
          completion(false, err)
          return
        })
        
        completion(true, nil)
        
      })
      
    }
  }
  
  static func handleUnfollowButton(withUserId userId: String, completion: @escaping (_ result: Bool, _ error: Error?) -> ()) {
    if !hasFirebaseMagicBeenStarted() { return }
    guard let currentLoggedInUserId = currentUserUid() else {
      completion(false, nil)
      return
    }
    Database_UserFollowing.child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
      if let err = err {
        print("Failed to unfollow user with err:", err)
        completion(false, err)
        return
      }
      print("Successfully unfollowed user with id:", userId)
      
      Database_UserFollowers.child(userId).removeValue(completionBlock: { (err, ref) in
        if let err = err {
          print("Failed to follow user with err:", err)
          completion(false, err)
          return
        }
        print("Successfully removed follower id:", currentLoggedInUserId)
        
        // remove unfollowed user orders from current user feed
        Database_UserOrders.child(userId).observe(.childAdded, with: { (snapshot) in
          let orderId = snapshot.key
          Database_UserTravel.child(currentLoggedInUserId).child(orderId).removeValue()
        }, withCancel: { (err) in
          print("Failed to remove followed user order into current user Traveller with error:", err)
          completion(false, err)
          return
        })
        
        completion(true, nil)
        
      })
      
    }
  }
  
  // MARK: -
  // MARK: Fetch user stats - Followers / Following
  static func fetchUserStats(forUid uid: String?, fetchType: StatFetchType, in collectionViewController: UICollectionViewController, completion: @escaping (_ result: Bool, _ error: Error?) -> ()) {
    if !hasFirebaseMagicBeenStarted() { return }
    guard let uid = uid else {
      completion(false, nil)
      return
    }
    print("Started fetching \(fetchType) for current user with id:", uid)
    
    if  (fetchType == .followers ? fetchedFollowerUsersCurrentKey : fetchedFollowingUsersCurrentKey) == nil {
      // initial pull
      let ref = fetchType == .followers ? Database_UserFollowers : Database_UserFollowing
      ref.child(uid).queryLimited(toLast: fetchType == .followers ? paginationElementsLimitFollowerUsers : paginationElementsLimitFollowingUsers).observeSingleEvent(of: .value, with: { (snapshot) in
        
        if snapshot.childrenCount == 0 {
          print("No follower / following users to fetch for current user.")
          completion(false, nil)
        }
        
        guard let allObjects = snapshot.children.allObjects as? [DataSnapshot], let first = snapshot.children.allObjects.first as? DataSnapshot else {
          completion(false, nil)
          return
        }
        
        allObjects.forEach({ (snapshot) in
          let uid = snapshot.key
          fetchUserStats(withUid: uid, fetchType: fetchType, in: collectionViewController, completion: { (result, err) in
            if let err = err {
              completion(result, err)
            } else if result == false {
              completion(result, err)
            }
            // not completing when (true, nil) because of pagination
          })
        })
        
        if fetchType == .followers {
          fetchedFollowerUsersCurrentKey = first.key
        } else {
          fetchedFollowingUsersCurrentKey = first.key
        }
        
        completion(true, nil)
      }) { (err) in
        print("Failed to query current user follower / following users:", err)
        completion(false, err)
      }
      
    } else {
      // paginate here
      let ref = fetchType == .followers ? Database_UserFollowers : Database_UserFollowing
      ref.child(uid).queryOrderedByKey().queryEnding(atValue: fetchType == .followers ? fetchedFollowerUsersCurrentKey : fetchedFollowingUsersCurrentKey).queryLimited(toLast: fetchType == .followers ? paginationElementsLimitFollowerUsers : paginationElementsLimitFollowingUsers).observeSingleEvent(of: .value, with: { (snapshot) in
        
        if snapshot.childrenCount == 0 {
          print("No follower / following users to fetch for current user.")
          completion(false, nil)
        }
        
        guard let allObjects = snapshot.children.allObjects as? [DataSnapshot], let first = snapshot.children.allObjects.first as? DataSnapshot else {
          completion(false, nil)
          return
        }
        
        allObjects.forEach({ (snapshot) in
          
          if snapshot.key != (fetchType == .followers ? fetchedFollowerUsersCurrentKey : fetchedFollowingUsersCurrentKey) {
            let uid = snapshot.key
            fetchUserStats(withUid: uid, fetchType: fetchType, in: collectionViewController, completion: { (result, err) in
              if let err = err {
                completion(result, err)
              } else if result == false {
                completion(result, err)
              }
              // not completing when (true, nil) because of pagination
            })
          }
          
        })
        
        if fetchType == .followers {
          fetchedFollowerUsersCurrentKey = first.key
        } else {
          fetchedFollowingUsersCurrentKey = first.key
        }
        
        completion(true, nil)
      }) { (err) in
        print("Failed to query and paginate current user follower / following users:", err)
        completion(false, err)
      }
    }
    
  }
  
  fileprivate static func fetchUserStats(withUid uid: String, fetchType: StatFetchType, in collectionViewController: UICollectionViewController, completion: @escaping (_ result: Bool, _ error: Error?) -> ()) {
    
    if uid == currentUserUid() {
      completion(false, nil)
      return
    }
    
    fetchUser(withUid: uid, fetchType: fetchType) { (user, err) in
      if let err = err {
        completion(false, err)
        return
      }
      guard let user = user else {
        completion(false, nil)
        return
      }
      
      switch fetchType {
      case .followers:
        fetchedFollowerUsers.insert(user, at: 0)
      case .following:
        fetchedFollowingUsers.insert(user, at: 0)
      }
      
      collectionViewController.collectionView?.reloadData()
      print("Fetched current user followers / following.")
      
      completion(true, nil)
    }
  }
  
  fileprivate static func fetchUser(withUid uid: String, fetchType: StatFetchType, completion: @escaping(_ user: CurrentUser?, _ error: Error?) -> ()) {
    let ref = fetchType == .followers ? Database_UserFollowers : Database_UserFollowing
    ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
      let ownerUid = snapshot.key
      
      fetchUser(withUid: ownerUid, completion: { (user, err) in
        if let err = err {
          completion(nil, err)
          return
        }
        
        guard let user = user else {
          completion(nil, nil)
          return
        }
        
        completion(user, nil)
      })
    }
  }
    
    static func fetchUserOrders2(forUid uid: String?, fetchType: OrderFetchType, in collectionViewController: UICollectionViewController, completion: @escaping ( _ result: [String : Any]?, _ error: Error?) -> ()) {
        if !hasFirebaseMagicBeenStarted() { return }
        
//        collectionViewController.collectionView?.backgroundView?.alpha = 0.0
//        if currentlyFetchingOrders {
//            completion(nil, nil)
//            return
//        }
//        currentlyFetchingOrders = true
        
//        guard let uid = uid else {
//            currentlyFetchingOrders = false
//            completion(nil, nil)
//            return
//        }
//        print("Started fetching (\(fetchType)) orders for current user with id:", uid)
//
        if  (fetchType == .onHome ? fetchedOrdersCurrentKey : fetchedUserOrdersCurrentKey) == nil {
            // initial pull
            let ref = fetchType == .onHome ? Database_Orders : Database_Orders
            
            
            ref.observe(DataEventType.childAdded) { (snapshot) in
                print(snapshot)
                return
            }
            
            
            ref.observe(.value , with :{ (snapshot ) in
                 if !hasFirebaseMagicBeenStarted() { return }
                guard let result = snapshot.value as? [String : Any] else {
                    completion(nil, nil)
                    return
                }
                
                completion(result,nil)
                return
//                if snapshot.childrenCount == 0 {
//                    print("No orders to fetch for user.")
//                    currentlyFetchingOrders = false
//                    collectionViewController.collectionView?.backgroundView?.alpha = 1.0
//                    collectionViewController.collectionView?.reloadData()
//                    completion(false, nil)
//                }
                
//                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot], let first = snapshot.children.allObjects.first as? DataSnapshot else {
//                    currentlyFetchingOrders = false
//                    completion(false, nil)
//                    return
//                }
                
//                allObjects.forEach({ (snapshot) in
//                    let orderId = snapshot.key
//                    fetchUserOrder(withOrderId: orderId, fetchType: fetchType, in: collectionViewController, completion: { (result, err) in
//                        if let err = err {
//                            currentlyFetchingOrders = false
//                            completion(result, err)
//                        } else if result == false {
//                            currentlyFetchingOrders = false
//                            completion(result, err)
//                        }
//                        // not completing when (true, nil) because of pagination
//                    })
               // })
                })
            }
        }
    }
    
    
  

