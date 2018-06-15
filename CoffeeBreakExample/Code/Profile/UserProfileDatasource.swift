//
//  UserProfileDatasource.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 22/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents
import JGProgressHUD

class UserProfileDatasource: Datasource {
  
  var user: CurrentUser?
  
  override func headerClasses() -> [DatasourceCell.Type]? {
    return [UserProfileHeaderDatasourceCell.self]
  }
  
  override func cellClasses() -> [DatasourceCell.Type] {
    return [UserProfilePostDatasourceCell.self]
  }
  
  override func headerItem(_ section: Int) -> Any? {
    return user
  }
  
  override func item(_ indexPath: IndexPath) -> Any? {
    // MARK: FirebaseMagic - Insert item
    if indexPath.item < FirebaseMagic.fetchedUserPosts.count {
      return FirebaseMagic.fetchedUserPosts[indexPath.item]
    } else {
      return 0
    }
  }
  
  override func numberOfItems(_ section: Int) -> Int {
    // MARK: FirebaseMagic - Number of items
    return FirebaseMagic.fetchedUserPosts.count
  }
  
  func fetchCurrentUser(in collectionViewController: UICollectionViewController, completion: @escaping (CurrentUser) -> ()) {
    // MARK: FirebaseMagic - Fetch Current User
    guard let uid = FirebaseMagic.currentUserUid() else { return }
    let hud = JGProgressHUD(style: .light)
    FirebaseMagic.showHud(hud, text: "Fetching user...")
    FirebaseMagic.fetchUser(withUid: uid) { (user, err) in
      if let err = err {
        hud.dismiss(animated: true)
        Service.showAlert(style: .alert, title: "Error fetching user", message: err.localizedDescription)
        return
      }
      guard let user = user else {
        hud.textLabel.text = "Something went wrong..."
        hud.dismiss(afterDelay: 1, animated: true)
        return
      }
      print("Successfully fetched user:", user.username)
      
      hud.dismiss(animated: true)
      self.user = user
      collectionViewController.collectionView?.reloadData()
      completion(user)
    }
    
  }
  
}
