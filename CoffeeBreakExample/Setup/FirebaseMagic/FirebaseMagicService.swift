//
//  FirebaseMagicService.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 24/06/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import UIKit
import JGProgressHUD

class FirebaseMagicService {
  // MARK: -
  // MARK: Show alert
  
  static func showAlert(style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actions {
      alert.addAction(action)
    }
    if let topVC = UIApplication.getTopMostViewController() {
      topVC.present(alert, animated: true, completion: completion)
    }
  }
  
  // MARK: -
  // MARK: Hud
  static func showHud(_ hud: JGProgressHUD, text: String) {
    hud.textLabel.text = text
    hud.interactionType = .blockAllTouches
    if let topVC = UIApplication.getTopMostViewController() {
      hud.show(in: topVC.view, animated: true)
    }
  }
  
  static func dismiss(_ hud: JGProgressHUD, afterDelay: TimeInterval?, text: String?) {
    if let text = text {
      hud.textLabel.text = text
    }
    if let afterDelay = afterDelay {
      hud.dismiss(afterDelay: afterDelay, animated: true)
    } else {
      hud.dismiss(animated: true)
    }
    
  }
  
}
