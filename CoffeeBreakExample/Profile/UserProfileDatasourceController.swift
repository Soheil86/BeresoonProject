//
//  UserProfileDatasourceController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents
import Firebase

class UserProfileDatasourceController: DatasourceController {
  
  let userProfileDatasource = UserProfileDatasource()
  
  lazy var logoutBarButtonItem: UIBarButtonItem = {
    var item = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogoutBarButtonItemTapped))
    return item
  }()
  
  @objc func handleLogoutBarButtonItemTapped() {
    let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
      // MARK: FirebaseMagic - Log out
      FirebaseMagic.logout(in: self, destinationViewController: SignUpController(), completion: { (result) in
        if result {
          self.deleteCurrentUserSession()
        }
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    Service.showAlert(onCollectionViewController: self, style: .actionSheet, title: nil, message: nil, actions: [logOutAction, cancelAction], completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datasource = userProfileDatasource
    
    setupController()
    
    fetchCurrentUser { (currentUser) in
      guard let currentUser = currentUser else { return }
      print("Current user fetched:", currentUser.username)
    }
  }
  
  fileprivate func setupController() {
    collectionView?.backgroundColor = .white
    navigationItem.title = "Me"
    navigationItem.setRightBarButton(logoutBarButtonItem, animated: false)
    collectionView?.showsVerticalScrollIndicator = false
  }
  
  fileprivate func deleteCurrentUserSession() {
    
  }
  
  fileprivate func fetchCurrentUser(completion: @escaping (CurrentUser?) -> ()) {
    // MARK: FirebaseMagic - Fetch Current User
    guard let uid = FirebaseMagic.currentUserUid() else { return }
    FirebaseMagic.fetchUserWith(uid, in: self) { (currentUser) in
      completion(currentUser)
    }
  }
}