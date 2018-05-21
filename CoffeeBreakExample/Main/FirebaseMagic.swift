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
  
  init() { }
  
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
  
  static func signUpUserWithEmail(in viewController: UIViewController, email: String?, password: String?) {
    guard let email = email, email.count > 0,
      let password = password, password.count > 5
      else {
      Service.showAlert(on: viewController, style: .alert, title: "Format error", message: "Please, enter valid values for the required fields and try again")
      return
    }
    let hud = JGProgressHUD(style: .light)
    showHud(hud, in: viewController, text: "Signing up with email...")
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
      if let err = err {
        print("Failed to create Firebase user:", err)
        hud.dismiss(animated: true)
        Service.showAlert(on: viewController, style: .alert, title: "Sign up error", message: err.localizedDescription)
        return
      }
      guard let result = result else { return }
      print("Successfully created firebase user:", result.user.uid )
      saveUserIntoFirebase(user: result.user)
    }
  }
  
  private static func saveUserIntoFirebase(user: User?) {
    
  }
  
  private static func showHud(_ hud: JGProgressHUD, in viewController: UIViewController, text: String) {
    hud.textLabel.text = text
    hud.show(in: viewController.view, animated: true)
  }
  
}
