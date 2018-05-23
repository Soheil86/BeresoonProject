//
//  UserProfilePostDatasourceCell.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 22/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class UserProfilePostDatasourceCell: DatasourceCell {
  
  lazy var mediaImageView: CachedImageView = {
    let imageView = CachedImageView()
    imageView.backgroundColor = Service.randomColor()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 5
    imageView.clipsToBounds = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleMediaImageViewTapped))
    imageView.addGestureRecognizer(tap)
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  @objc fileprivate func handleMediaImageViewTapped() {
    
  }
  
  override var datasourceItem: Any? {
    didSet {
      guard let post = datasourceItem as? Post else { return }
      mediaImageView.loadImage(urlString: post.thumbnailUrl) {
        
      }
    }
  }
  
  override func setupViews() {
    super.setupViews()
    
    self.addSubview(mediaImageView)
    
    mediaImageView.fillSuperview()
  }
  
}
