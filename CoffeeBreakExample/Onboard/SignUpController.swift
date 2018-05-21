//
//  SignUpController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let profilePictureWidth = ScreenSize.width * 0.18
  lazy var addProfilePictureButton: UIButton = {
    var button = UIButton(type: .system)
    button.backgroundColor = UIColor.white
    button.setImage(#imageLiteral(resourceName: "AddProfilePicture").withRenderingMode(.alwaysOriginal), for: .normal)
    //    button.tintColor = UIColor(red: 218, green: 218, blue: 218)
    button.imageView?.contentMode = .scaleAspectFill
    button.layer.masksToBounds = true
    button.layer.cornerRadius = profilePictureWidth * 0.5
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 2.0
    button.layer.zPosition = 2
    button.addTarget(self, action: #selector(handleAddProfilePictureButtonTapped), for: .touchUpInside)
    return button
  }()
  
  @objc func handleAddProfilePictureButtonTapped() {
    showChooseSourceTypeAlertController()
  }
  
  func showChooseSourceTypeAlertController() {
    let photoLibraryAction = UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
      self.showImagePickerController(sourceType: .photoLibrary)
    }
    let cameraAction = UIAlertAction(title: "Take a New Photo", style: .default) { (action) in
      self.showImagePickerController(sourceType: .camera)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
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
      addProfilePictureButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      addProfilePictureButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    dismiss(animated: true, completion: nil)
  }
  
  let textFieldFontSize: CGFloat = 17
  let textFieldHeight: CGFloat = 30
  lazy var nameTextField: UITextField = {
    var tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.autocapitalizationType = .words
    tf.placeholder = "Name"
    tf.font = .systemFont(ofSize: textFieldFontSize)
    tf.addTarget(self, action: #selector(checkAllTextFields), for: .editingChanged)
    return tf
  }()
  
  lazy var emailTextField: UITextField = {
    var tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.autocapitalizationType = .none
    tf.placeholder = "Email"
    tf.font = .systemFont(ofSize: textFieldFontSize)
    tf.addTarget(self, action: #selector(checkAllTextFields), for: .editingChanged)
    return tf
  }()
  
  lazy var usernameTextField: UITextField = {
    var tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.autocapitalizationType = .none
    tf.placeholder = "Username"
    tf.font = .systemFont(ofSize: textFieldFontSize)
    tf.addTarget(self, action: #selector(checkAllTextFields), for: .editingChanged)
    return tf
  }()
  
  lazy var passwordTextField: UITextField = {
    var tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.placeholder = "Password"
    tf.font = .systemFont(ofSize: textFieldFontSize)
    tf.addTarget(self, action: #selector(checkAllTextFields), for: .editingChanged)
    return tf
  }()
  
  let orTextLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = "- or -"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 13)
    label.textColor = Setup.greyFontColor
    return label
  }()
  
  let facebookButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "Facebook", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.backgroundColor = UIColor(r: 88, g: 86, b: 214)
    button.setImage(#imageLiteral(resourceName: "FacebookButton").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .white
    button.contentMode = .scaleAspectFit
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 7
    button.addTarget(self, action: #selector(handleFacebookButtonTapped), for: .touchUpInside)
    return button
  }()
  
  @objc func handleFacebookButtonTapped() {
    
  }
  
  @objc func checkAllTextFields() {
    guard let name = nameTextField.text else { return }
    guard let email = emailTextField.text else { return }
    guard let username = usernameTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    let isFormValid = name.count > 0 && email.count > 0 && username.count > 0 && password.count > 0
    
    if isFormValid {
      nextBarButtonItem.isEnabled = true
    } else {
      nextBarButtonItem.isEnabled = false
    }
  }
  
  lazy var nextBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Sign Up", style: .done, target: self, action: #selector(handleNextBarButtonItemTapped))
    item.isEnabled = false
    return item
  }()

  @objc fileprivate func handleNextBarButtonItemTapped() {
    guard let name = nameTextField.text, name.count > 0 else { return }
    guard let email = emailTextField.text, email.count > 0 else { return }
    guard let username = usernameTextField.text, username.count > 0 else { return }
    guard let password = passwordTextField.text, password.count > 0 else { return }
    guard let profileImage = addProfilePictureButton.imageView?.image else { return }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationItem.title = "Create Account"
    
    navigationItem.setRightBarButton(nextBarButtonItem, animated: false)
    
    setupViews()
  }
  
  fileprivate func setupViews() {
    view.addSubview(addProfilePictureButton)
    view.addSubview(nameTextField)
    view.addSubview(emailTextField)
    view.addSubview(usernameTextField)
    view.addSubview(passwordTextField)
    view.addSubview(orTextLabel)
    view.addSubview(facebookButton)
    
    addProfilePictureButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 32, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: profilePictureWidth, heightConstant: profilePictureWidth)
    addProfilePictureButton.anchorCenterXToSuperview()
    
    nameTextField.anchor(addProfilePictureButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    emailTextField.anchor(nameTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    usernameTextField.anchor(emailTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    passwordTextField.anchor(usernameTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    
    orTextLabel.anchor(passwordTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 24, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    
    facebookButton.anchor(orTextLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 24, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 50)
  }
}