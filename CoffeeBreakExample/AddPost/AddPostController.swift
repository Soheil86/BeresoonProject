//
//  AddPostController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class AddPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var sourceType: UIImagePickerControllerSourceType?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    presentImagePickerController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
  }
  
  func presentImagePickerController() {
    guard let sourceType = sourceType else {
      dismiss(animated: true, completion: nil)
      return
    }
    showImagePickerController(sourceType: sourceType)
  }
  
  func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.sourceType = sourceType
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: false)
  }
}
