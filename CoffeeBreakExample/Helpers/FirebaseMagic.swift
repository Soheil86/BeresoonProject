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
      saveUserIntoFirebase(user: result.user, userDetails: userDetails, completion: { (result, err) in
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
  
  private static func saveUserIntoFirebase(user: User?, userDetails: [String : Any]?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let user = user,
      let email = user.email else {
      completion(false, nil)
      return
    }
    
    let uid = user.uid
    var mutableUserDetails: [String : Any] = [keyEmail : email]
    
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
          
          updateValues(at: Database_Users.child(uid), with: mutableUserDetails, completion: { (result, err) in
            completion(result, err)
          })
        }
      } else {
        updateValues(at: Database_Users.child(uid), with: mutableUserDetails, completion: { (result, err) in
          completion(result, err)
        })
      }
    } else {
      updateValues(at: Database_Users.child(uid), with: mutableUserDetails, completion: { (result, err) in
        completion(result, err)
      })
    }
    
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
