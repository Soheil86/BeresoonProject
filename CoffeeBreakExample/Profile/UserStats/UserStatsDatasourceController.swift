//
//  UserStatsDatasourceController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 27/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class UserStatsDatasourceController: DatasourceController, UISearchBarDelegate {
  
  let userStatsDatasource = UserStatsDatasource()
  
  lazy var backBarButtonItem: UIBarButtonItem = {
    var item = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackBarButtonItemTapped))
    return item
  }()
  
  @objc func handleBackBarButtonItemTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    collectionView?.alwaysBounceVertical = true
    collectionView?.showsVerticalScrollIndicator = false
    guard let navBar = navigationController?.navigationBar else { return }
    navBar.barTintColor = .white
    navigationItem.title = "Following"
    navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
    
    datasource = userStatsDatasource
    
  }
  
  @objc func handleUpdateSearchDatasourceController() {
    collectionView?.reloadData()
  }
  
  override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ScreenSize.width, height: 72)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}


















