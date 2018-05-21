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
  
  static let FMDatabase = Database.database().reference()
  static let Storage_ProfileImages_File = Storage.storage().reference().child("profile_images").child(UUID().uuidString)
  static let CurrentUserUid = Auth.auth().currentUser?.uid
  
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
  
  static func signUpUserWithEmail(in viewController: UIViewController, email: String?, password: String?, profilePicture: UIImage?, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let email = email, email.count > 0,
      let password = password, password.count > 5,
      let profilePicture = profilePicture
      else {
      Service.showAlert(on: viewController, style: .alert, title: "Format error", message: "Please, enter valid values for the required fields and try again")
        completion(false, nil)
      return
    }
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
      if let err = err {
        print("Failed to create Firebase user:", err)
        completion(false, err)
        return
      }
      guard let result = result else { return }
      print("Successfully created firebase user:", result.user.uid )
      saveUserIntoFirebase(user: result.user, profilePicture: profilePicture, completion: { (result, err) in
        completion(result, err)
      })
    }
  }
  
  private static func saveUserIntoFirebase(user: User?, profilePicture: UIImage, completion: @escaping (_ result: Bool, _ error: Error?) ->()) {
    guard let profilePictureUploadData = UIImageJPEGRepresentation(profilePicture, 0.3) else {
      completion(false, nil)
      return
    }
    
//    Storage_ProfileImages_File.putData(profilePictureUploadData, metadata: nil) { (metadata, err) in
//      <#code#>
//    }
  }
  
  static func showHud(_ hud: JGProgressHUD, in viewController: UIViewController, text: String) {
    hud.textLabel.text = text
    hud.show(in: viewController.view, animated: true)
  }
  
}
