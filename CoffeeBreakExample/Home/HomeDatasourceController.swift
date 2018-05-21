//
//  HomeDatasourceController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class HomeDatasourceController: DatasourceController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupController()
    
  }
  
  func setupController() {
    collectionView?.backgroundColor = .white
    navigationItem.title = "Home"
    collectionView?.showsVerticalScrollIndicator = false
  }
}
