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
  
}
