//
//  UserProfileDatasourceController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents
import Firebase
import JGProgressHUD

class UserProfileDatasourceController: DatasourceController {
  
  let userProfileDatasource = UserProfileDatasource()
  
  lazy var refreshControl : UIRefreshControl = {
    var rc = self.getRefreshControl()
    return rc
  }()
  
  lazy var logoutBarButtonItem: UIBarButtonItem = {
    var item = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogoutBarButtonItemTapped))
    return item
  }()
  
  @objc func handleLogoutBarButtonItemTapped() {
    let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
      // MARK: FirebaseMagic - Log out
      let hud = JGProgressHUD(style: .light)
      FirebaseMagic.showHud(hud, in: self, text: "Logging out...")
      FirebaseMagic.logout(completion: { (err) in
        hud.dismiss(animated: true)
        
        if let err = err {
          Service.showAlert(on: self, style: .alert, title: "Logout Error", message: err.localizedDescription)
          return
        }
        
        self.deleteCurrentUserSession()
        let controller = SignUpController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    Service.showAlert(onCollectionViewController: self, style: .actionSheet, title: nil, message: nil, actions: [logOutAction, cancelAction], completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datasource = userProfileDatasource
    collectionView?.refreshControl = refreshControl
    
    setupController()
    
    clearPosts()
    
    userProfileDatasource.fetchCurrentUser(in: self) { (currentUser) in
      self.navigationItem.title = currentUser.username
      self.fetchPosts()
    }
  }
  
  fileprivate func setupController() {
    collectionView?.backgroundColor = .white
    navigationItem.title = "Me"
    navigationItem.setRightBarButton(logoutBarButtonItem, animated: false)
    collectionView?.showsVerticalScrollIndicator = false
  }
  
  fileprivate func clearPosts() {
    // MARK: FirebaseMagic - Removing current posts if any
    FirebaseMagic.fetchedUserPosts.removeAll()
    FirebaseMagic.fetchedUserPostsCurrentKey = nil
    collectionView?.reloadData()
  }
  
  fileprivate func fetchPosts() {
    // MARK: FirebaseMagic - Fetch user posts
    let hud = JGProgressHUD(style: .light)
    FirebaseMagic.showHud(hud, in: self, text: "Fetching user posts...")
    FirebaseMagic.fetchUserPosts(forUid: FirebaseMagic.currentUserUid(), in: self, completion: { (result, err) in
      if let err = err {
        print("Failed to fetch user posts with err:", err)
        hud.dismiss(animated: true)
        Service.showAlert(onCollectionViewController: self, style: .alert, title: "Fetch error", message: "Failed to fetch user posts with err: \(err)")
        return
      } else if result == false {
        hud.textLabel.text = "Something went wrong..."
        hud.dismiss(afterDelay: 1, animated: true)
        return
      }
      print("Successfully fetched user posts")
      hud.dismiss(animated: true)
    })
  }
  
  fileprivate func reloadAllPosts() {
    clearPosts()
    fetchPosts()
  }
  
  override func handleRefresh() {
    reloadAllPosts()
  }
  
  fileprivate func deleteCurrentUserSession() {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: ScreenSize.width, height: 180)
  }
  
  override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (ScreenSize.width - 1)// / 2
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
}
