//
//  HomeDatasource.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 27/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents
import JGProgressHUD

class HomeDatasource: Datasource {
  
  var user: CurrentUser?
  
  override func cellClasses() -> [DatasourceCell.Type] {
    return [HomePostDatasourceCell.self]
  }
  
  override func headerItem(_ section: Int) -> Any? {
    return user
  }
  
  override func item(_ indexPath: IndexPath) -> Any? {
    // MARK: FirebaseMagic - insert item
    if indexPath.item < FirebaseMagic.fetchedPosts.count {
      return FirebaseMagic.fetchedPosts[indexPath.item]
    } else {
      return 0
    }
  }
  
  override func numberOfItems(_ section: Int) -> Int {
    // MARK: FirebaseMagic - number of items
    return FirebaseMagic.fetchedPosts.count
  }
  
//  func fetchCurrentUser(in collectionViewController: UICollectionViewController, completion: @escaping (CurrentUser) -> ()) {
//    // MARK: FirebaseMagic - Fetch Current User
//    guard let uid = FirebaseMagic.currentUserUid() else { return }
//    let hud = JGProgressHUD(style: .light)
//    FirebaseMagic.showHud(hud, in: collectionViewController, text: "Fetching user...")
//    FirebaseMagic.fetchUser(withUid: uid) { (user, err) in
//      if let err = err {
//        hud.dismiss(animated: true)
//        Service.showAlert(onCollectionViewController: collectionViewController, style: .alert, title: "Error fetching user", message: err.localizedDescription)
//        return
//      }
//      guard let user = user else {
//        hud.textLabel.text = "Something went wrong..."
//        hud.dismiss(afterDelay: 1, animated: true)
//        return
//      }
//      print("Successfully fetched user:", user.username)
//      
//      hud.dismiss(animated: true)
//      self.user = user
//      collectionViewController.collectionView?.reloadData()
//      completion(user)
//    }
//    
//  }
  
}
