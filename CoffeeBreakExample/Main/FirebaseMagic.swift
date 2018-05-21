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
  
  static func signUpUserWithEmail(in viewController: UIViewController) {
    let hud = JGProgressHUD(style: .light)
    showHud(hud, in: viewController, text: "Signing up with email...")
    
    hud.dismiss(afterDelay: 3, animated: true)
  }
  
  
  private static func showHud(_ hud: JGProgressHUD,in viewController: UIViewController, text: String) {
    hud.textLabel.text = text
    hud.show(in: viewController.view, animated: true)
  }
  
  
}
