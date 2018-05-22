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
import IQKeyboardManagerSwift
import JGProgressHUD

class FirebaseMagic {
  
  static let Database_Users = Database.database().reference().child("users")
  static let Database_Usernames = Database.database().reference().child("usernames")
  static let Storage_ProfileImages = Storage.storage().reference().child("profile_images")
  static let CurrentUserUid = Auth.auth().currentUser?.uid
  
  static var fetchedPosts = [Post]()
  static var fetchedCurrentUserPosts = [Post]()
  
  static func start() {
    IQKeyboardManager.shared.enable = true
    FirebaseApp.configure()
  }
  
  static func checkIfUserIsSignedIn(on viewController: UIViewController, signUpViewController: UIViewController) {
    if Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        
        // clear old data
        // TODO:
        //        Service.fetchedPosts.removeAll()
        //        Service.fetchedCurrentUserPosts.removeAll()
        
        let navController = UINavigationController(rootViewController: signUpViewController)
        viewController.present(navController, animated: false, completion: nil)
      }
      return
    }
  }
  
  static func logout(in viewController: UIViewController, destinationViewController: UIViewController, completion: @escaping (_ result: Bool) ->()) {
    do {
      try Auth.auth().signOut()
      let navController = UINavigationController(rootViewController: destinationViewController)
      viewController.present(navController, animated: true, completion: nil)
      completion(true)
    } catch let err {
      print("Failed to sign out with error:", err)
      Service.showAlert(on: viewController, style: .alert, title: "Logout Error", message: err.localizedDescription)
      completion(false)
    }
  }
  
  static func signUpUserWithEmail(in viewController: UIViewController, userCredentials: [String : Any], userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let username = userCredentials[keyUsername] as? String else {
      completion(false, nil)
      return
    }
    fetchUserWithUsername(searchText: username.lowercased().replacingOccurrences(of: " ", with: "_"), in: viewController, limitedToFirst: 1) { (user) in
      if user == nil {
        
        FirebaseMagic.signUpUniqueUserWithEmail(in: viewController, userCredentials: userCredentials, userDetails: userDetails) { (result, err) in
          completion(result, err)
        }
        
      } else {
        
        let textField = UITextField()
        textField.placeholder = "New Username"
        textField.autocapitalizationType = .none
        
        Service.showAlert(on: viewController, style: .alert, title: "Sign Up Error", message: "The username '\(username.lowercased())' is already taken. Please, choose another one.", textFields: [textField], completion: { (usernames) in
          guard let usernames = usernames, let username = usernames.first else {
            completion(false, nil)
            return
          }
          var mutableUserCredentials = userCredentials
          mutableUserCredentials.updateValue(username, forKey: keyUsername)
          signUpUserWithEmail(in: viewController, userCredentials: mutableUserCredentials, userDetails: userDetails, completion: { (result, err) in
            completion(result, err)
          })
        })
        
      }
    }
  }
  
  private static func signUpUniqueUserWithEmail(in viewController: UIViewController, userCredentials: [String : Any], userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let email = userCredentials[keyEmail] as? String,
      let password = userCredentials[keyPassword] as? String else {
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
  
  private static func saveUserIntoFirebase(user: User?, userCredentials: [String : Any], userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let user = user,
      let email = user.email,
      let username = userCredentials[keyUsername] as? String else {
      completion(false, nil)
      return
    }
    
    let uid = user.uid
    var mutableUserDetails: [String : Any] = [keyUsername: username.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "#", with: "_").replacingOccurrences(of: "$", with: "_").replacingOccurrences(of: "[", with: "_").replacingOccurrences(of: "]", with: "_").replacingOccurrences(of: "/", with: "_"), keyEmail : email]
    
    if let userDetails = userDetails {
      mutableUserDetails.update(with: userDetails)
      
      if let profileImage = mutableUserDetails[keyProfileImage] as? UIImage {
        saveImage(profileImage, path: Storage_ProfileImages) { (imageUrl, result, err) in
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
          
          mutableUserDetails.updateValue(imageUrl, forKey: keyProfileImageUrl)
          mutableUserDetails.removeValue(forKey: keyProfileImage)
          
          updateUserValues(uid: uid, with: mutableUserDetails, username: username, email: email) { (result, err) in
            completion(result, err)
          }
          
        }
      } else {
        
        updateUserValues(uid: uid, with: mutableUserDetails, username: username, email: email) { (result, err) in
          completion(result, err)
        }
        
      }
    } else {
      
      updateUserValues(uid: uid, with: mutableUserDetails, username: username, email: email) { (result, err) in
        completion(result, err)
      }
      
    }
    
  }
  
  private static func updateUserValues(uid: String, with dictionary: [String : Any], username: String, email: String,  completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    
    updateValues(at: Database_Users.child(uid), with: dictionary, completion: { (result, err) in
      if let err = err {
        completion(false, err)
        return
      } else if result == false {
        completion(false, nil)
        return
      }
      updateValues(at: Database_Usernames, with: [username.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "#", with: "_").replacingOccurrences(of: "$", with: "_").replacingOccurrences(of: "[", with: "_").replacingOccurrences(of: "]", with: "_").replacingOccurrences(of: "/", with: "_") : email], completion: { (result, err) in
        completion(result, err)
      })
    })
  }
  
  private static func updateValues(at path: DatabaseReference, with dictionary: [String : Any],  completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    path.updateChildValues(dictionary) { (err, ref) in
      if let err = err {
        print("Failed to save user info into Firebase database with error:", err)
        completion(false, err)
        return
      }
      print("Successfully saved user info into Firebase database")
      completion(true, nil)
    }
  }
  
  private static func saveImage(_ image: UIImage, path: StorageReference, completion: @escaping (_ imageUrl: String?, _ result: Bool, _ error: Error?) ->()) {
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
  
  static func fetchUserWithUsername(searchText: String, in viewController: UIViewController, limitedToFirst: Int, completion: @escaping ([CurrentUser]?) -> ()) {
    
    print("Search text:", searchText)
    var filteredUsers: [CurrentUser] = []
    let lowerCasedSearchText = searchText.lowercased()
    let userRef = Database_Users.queryLimited(toFirst: UInt(limitedToFirst)).queryOrdered(byChild: keyUsername).queryStarting(atValue: lowerCasedSearchText).queryEnding(atValue: lowerCasedSearchText+"\u{f8ff}")
    
    userRef.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if snapshot.exists() {
        guard let dictionaries = snapshot.value as? [String: Any] else { return }
        
        dictionaries.forEach({ (key, value) in
          if key == currentUserUid() {
            return
          }
          guard let userDictionary = value as? [String: Any] else { return }
          let user = CurrentUser(uid: key, dictionary: userDictionary)
          
          let isContained = filteredUsers.contains(where: { (containedUser) -> Bool in
            return user.uid == containedUser.uid
          })
          if !isContained {
            filteredUsers.append(user)
          }
          
        })
        print("Filtered users:", filteredUsers)
        completion(filteredUsers)
      } else {
        print("No users available")
        completion(nil)
      }
      
    }) { (err) in
      print("Failed to fetch users:", err)
      Service.showAlert(on: viewController, style: .alert, title: "Fetch error", message: err.localizedDescription)
    }
  }
  
  static func currentUserUid() -> String? {
    return Auth.auth().currentUser?.uid
  }
  
  static func fetchUserWith(_ uid: String, in collectionViewController: UICollectionViewController, completion: @escaping (CurrentUser?) -> ()) {
    Database_Users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      guard let dictionary = snapshot.value as? [String : Any] else { return }
      let user = CurrentUser(uid: uid, dictionary: dictionary)
      completion(user)
    }) { (err) in
      print("Failed to fetch user:", err)
      Service.showAlert(on: collectionViewController, style: .alert, title: "Fetch error", message: err.localizedDescription)
      completion(nil)
    }
  }
  
  static func showHud(_ hud: JGProgressHUD, in viewController: UIViewController, text: String) {
    hud.textLabel.text = text
    hud.show(in: viewController.view, animated: true)
  }
  
}
