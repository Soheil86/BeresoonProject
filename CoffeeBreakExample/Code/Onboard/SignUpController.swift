//
//  SignUpController.swift
//  CoffeeBreakExample
//
//  Created by Alex Nagy on 21/05/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import LBTAComponents
import JGProgressHUD
import Firebase
import GoogleSignIn

class SignUpController: UIViewController, GIDSignInUIDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    let headerImageViewHeight = ScreenSize.width * 0.3
    let textFieldFontSize: CGFloat = 20
    let textFieldHeight: CGFloat = 40
    let profilePictureWidth = ScreenSize.width * 0.18
    
    let headerImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "logo")
        view.contentMode = .scaleToFill
        return view
    }()
    
    //    let headerIconImageView: UIImageView = {
    //        let view = UIImageView()
    //        view.image = #imageLiteral(resourceName: "IconBW")
    //        view.contentMode = .scaleAspectFill
    //        return view
    //    }()
    
    lazy var addProfilePictureButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setImage(#imageLiteral(resourceName: "AddProfilePicture").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        button.layer.cornerRadius = profilePictureWidth * 0.5
        button.layer.borderColor = Setup.greyColor.cgColor
        button.layer.borderWidth = 0.5
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
        FirebaseMagicService.showAlert(style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
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
    
    lazy var signInWithFacebookButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("LOGIN WITH FACEBOOK", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = Service.buttonBackgroundColorSignInWithFacebook
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Service.buttonCornerRadius
        
        button.setImage(#imageLiteral(resourceName: "FacebookButton").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(handleSignInWithFacebookButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignInWithFacebookButtonTapped() {
        
        hud.textLabel.text = "Signing in With Facebook..."
        hud.show(in: view)
        
        Spark.signInWithFacebook(in: self) { (message, err, sparkUser) in
            if let err = err {
                SparkService.dismissHud(self.hud, text:"Error" ,
                                        detailText: "\(message) \(err.localizedDescription)", delay: 3)
            }
            
            guard let sparkUser = sparkUser else
            {
                SparkService.dismissHud(
                    self.hud, text: "Error", detailText: "Failed To Fetch User", delay: 3)
                return
            }
            
            print("Successfully signed in with Facebook with Spark User: \(sparkUser)")
            SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully signed in with Facebook", delay: 3)
            
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        self.dismissSignUpController()
        let homeController = HomeDatasourceController()
        navigationController?.pushViewController(homeController, animated: true)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    
    
    let signInWithGoogleButton: UIButton = {
        let GoogleButton = UIButton(type: .custom)
        
        GoogleButton.setTitle("LOGIN WITH GOOGLE",for:.normal)
        GoogleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        GoogleButton.setTitleColor(Service.buttonTitleColor, for: .normal)
        GoogleButton.backgroundColor = Service.buttonBackgroundColorSignInWithGmail
        GoogleButton.layer.masksToBounds = true
        GoogleButton.layer.cornerRadius = Service.buttonCornerRadius
        
        GoogleButton.setImage(
            UIImage(named:"icons8-google_logo"),
            for: UIControlState.normal)
        //GoogleButton.setImage(UIAccessibilityTraitImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
        
        // GoogleButton.tintColor = .white
        GoogleButton.contentMode = .scaleAspectFit
        
        GoogleButton.addTarget(self, action: #selector(handleSignInWithGoogleButtonTapped), for: .touchUpInside)
        return GoogleButton
    }()
    
    
    @objc func handleSignInWithGoogleButtonTapped() {
        
        GIDSignIn.sharedInstance().signIn()
        self.dismissSignUpController()
        let homeController = HomeDatasourceController()
        navigationController?.pushViewController(homeController, animated: true)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        print("Google Sing In didSignInForUser")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        // When user is signed in
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
        })
    }
    // Start Google OAuth2 Authentication
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        // Showing OAuth2 authentication window
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        dismiss(animated: true) {() -> Void in }
    }
    
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: Setup.lightGreyColor])
        attributedTitle.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: Setup.blueColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLoginButtonTapped() {
        let loginController = LoginController()
        let loginNavController = UINavigationController(rootViewController: loginController)
        present(loginNavController, animated: true, completion: nil)
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
        
        guard let emailAddress = emailTextField.text, emailAddress.count > 0,
            let password = passwordTextField.text, password.count > 5,
            let name = nameTextField.text, name.count > 0,
            let username = usernameTextField.text, username.count > 2,
            let profileImage = addProfilePictureButton.imageView?.image else {
                FirebaseMagicService.showAlert(style: .alert, title: "Format error", message: "Please, enter valid values for the required fields and try again")
                return
        }
        
        let userCredentials = [FirebaseMagicKeys.User.emailAddress: emailAddress,
                               FirebaseMagicKeys.User.password: password,
                               FirebaseMagicKeys.User.username: username] as [String : Any]
        
        let userDetails = [FirebaseMagicKeys.User.profileImage: profileImage,
                           FirebaseMagicKeys.User.name: name] as [String : Any]
        
        // Mark: FirebaseMagic - Sign up user with email
        let hud = JGProgressHUD(style: .light)
        FirebaseMagicService.showHud(hud, text: "Signing up with email...")
        FirebaseMagic.signUpUserWithEmail(userCredentials: userCredentials, userDetails: userDetails) { (result, err) in
            if let err = err {
                FirebaseMagicService.dismiss(hud, afterDelay: nil, text: nil)
                FirebaseMagicService.showAlert(style: .alert, title: "Sign up error", message: err.localizedDescription)
                return
            } else if result == false {
                FirebaseMagicService.dismiss(hud, afterDelay: nil, text: "Something went wrong...")
                return
            }
            print("Successfully signed up with email.")
            FirebaseMagicService.dismiss(hud, afterDelay: nil, text: nil)
            self.dismissSignUpController()
        }
        
    }
    
    func dismissSignUpController() {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        DispatchQueue.main.async {
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance().signIn()
        
        view.backgroundColor = .white
        navigationItem.title = "Create Account"
        
        navigationItem.setRightBarButton(nextBarButtonItem, animated: false)
        
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        view.addSubview(headerImageView)
        // headerImageView.addSubview(headerIconImageView)
        view.addSubview(addProfilePictureButton)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInWithFacebookButton)
        view.addSubview(signInWithGoogleButton)
        view.addSubview(loginButton)
        
        headerImageView.anchor(
            view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 0,
            leftConstant: 0,
            bottomConstant: 0,
            rightConstant: 0,
            widthConstant: 0,
            heightConstant: headerImageViewHeight)
        
        //        headerIconImageView.anchor(
        //            nil,
        //            left: nil,
        //            bottom: nil,
        //            right: nil,
        //            topConstant: 0,
        //            leftConstant: 0,
        //            bottomConstant: 0,
        //            rightConstant: 0,
        //            widthConstant: headerImageViewHeight * 0.5,
        //            heightConstant: headerImageViewHeight * 0.5)
        //        headerIconImageView.anchorCenterSuperview()
        
        addProfilePictureButton.anchor(
            view.safeAreaLayoutGuide.topAnchor,
            left: nil,
            bottom: nil,
            right: nil,
            topConstant: headerImageViewHeight + 24,
            leftConstant: 0,
            bottomConstant: 0,
            rightConstant: 0,
            widthConstant: profilePictureWidth,
            heightConstant: profilePictureWidth)
        addProfilePictureButton.anchorCenterXToSuperview()
        
        nameTextField.anchor(
            addProfilePictureButton.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 12,
            leftConstant: 12,
            bottomConstant: 0,
            rightConstant: 12,
            widthConstant: 0,
            heightConstant: textFieldHeight)
        
        emailTextField.anchor(
            nameTextField.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 12,
            leftConstant: 12,
            bottomConstant: 0,
            rightConstant: 12,
            widthConstant: 0,
            heightConstant: textFieldHeight)
        
        usernameTextField.anchor(
            emailTextField.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 12,
            leftConstant: 12,
            bottomConstant: 0,
            rightConstant: 12,
            widthConstant: 0,
            heightConstant: textFieldHeight)
        
        passwordTextField.anchor(
            usernameTextField.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 12,
            leftConstant: 12,
            bottomConstant: 0,
            rightConstant: 12,
            widthConstant: 0,
            heightConstant: textFieldHeight)
        
        signInWithFacebookButton.anchor(
            passwordTextField.bottomAnchor,
            left:view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 32,
            leftConstant: 12,
            bottomConstant: 0,
            rightConstant: 12,
            widthConstant: 0,
            heightConstant: 50
        )
        
        signInWithGoogleButton.anchor(
            signInWithFacebookButton.bottomAnchor,
            left:view.safeAreaLayoutGuide.leftAnchor,
            bottom: nil,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 32,
            leftConstant: 12,
            bottomConstant: 0,
            rightConstant: 12,
            widthConstant: 0,
            heightConstant: 50
        )
        
        loginButton.anchor(
            nil,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            topConstant: 0,
            leftConstant: 0,
            bottomConstant: 36,
            rightConstant: 0,
            widthConstant: 0,
            heightConstant: 50)
    }
}
