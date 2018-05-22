//
//  Service.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class Service {
  
  static let notificationNameShouldDismissViewController = Notification.Name(rawValue: "shouldDismissViewController")
  
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
  
  static func showAlert(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, textFields: [UITextField], completion: @escaping ([String]) -> ()) {
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
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alert.addAction(cancelAction)
    
    on.present(alert, animated: true, completion: nil)
  }
  
}
