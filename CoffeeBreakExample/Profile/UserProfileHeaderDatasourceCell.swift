//
//  UserProfileHeaderDatasourceCell.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 22/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class UserProfileHeaderDatasourceCell: DatasourceCell {
  
  override var datasourceItem: Any? {
    didSet {
      guard let user = datasourceItem as? CurrentUser else { return }
      
    }
  }
  
  override func setupViews() {
    super.setupViews()
  }
  
}
