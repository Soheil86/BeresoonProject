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
    // MARK: FirebaseMagic - insert item
    if indexPath.item < FirebaseMagic.fetchedCurrentUserPosts.count {
      return FirebaseMagic.fetchedCurrentUserPosts[indexPath.item]
    } else {
      return 0
    }
  }
  
  override func numberOfItems(_ section: Int) -> Int {
    // MARK: FirebaseMagic - number of items
    return FirebaseMagic.fetchedCurrentUserPosts.count
  }
  
  func fetchCurrentUser(in collectionViewController: UICollectionViewController, completion: @escaping (CurrentUser) -> ()) {
    // MARK: FirebaseMagic - Fetch Current User
    guard let uid = FirebaseMagic.currentUserUid() else { return }
    let hud = JGProgressHUD(style: .light)
    FirebaseMagic.showHud(hud, in: collectionViewController, text: "Fetching user...")
    FirebaseMagic.fetchUserWith(uid, in: collectionViewController) { (currentUser) in
      guard let user = currentUser else {
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
