//
//  Service.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import UIKit
import LBTAComponents

class Service {
  
  static let notificationNameShouldDismissViewController = Notification.Name(rawValue: "shouldDismissViewController")
  static let notificationNameUserSharedAPost = Notification.Name(rawValue: "userSharedAPost")
  static let notificationNameUpdateSearchDatasourceController = Notification.Name(rawValue: "updateSearchDatasourceController")
  static let notificationNameFollowedUser = Notification.Name(rawValue: "followedUser")
  static let notificationNameUnfollowedUser = Notification.Name(rawValue: "unfollowedUser")
  static let notificationNameShowFollowers = Notification.Name(rawValue: "showFollowers")
  static let notificationNameShowFollowing = Notification.Name(rawValue: "showFollowing")
  
  static func showAlert(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actions {
      alert.addAction(action)
    }
    on.present(alert, animated: true, completion: completion)
  }
  
  static func showAlert(onCollectionViewController: UICollectionViewController, style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actions {
      alert.addAction(action)
    }
    onCollectionViewController.present(alert, animated: true, completion: completion)
  }
  
  static func showAlert(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, textFields: [UITextField], completion: @escaping ([String]?) -> ()) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    
    for textField in textFields {
      alert.addTextField(configurationHandler: { (theTextField) in
        theTextField.placeholder = textField.placeholder
      })
    }
    
    let textFieldAction = UIAlertAction(title: "Submit", style: .cancel) { (action) in
      var textFieldsTexts: [String] = []
      if let alertTextFields = alert.textFields {
        for textField in alertTextFields {
          if let textFieldText = textField.text {
            textFieldsTexts.append(textFieldText)
          }
        }
        completion(textFieldsTexts)
      }
    }
    alert.addAction(textFieldAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
      completion(nil)
    }
    alert.addAction(cancelAction)
    
    on.present(alert, animated: true, completion: nil)
  }
  
  static func randomColor() -> UIColor {
    return UIColor(r: CGFloat.random(0, max: 255), g: CGFloat.random(0, max: 255), b: CGFloat.random(0, max: 255))
  }
  
}
