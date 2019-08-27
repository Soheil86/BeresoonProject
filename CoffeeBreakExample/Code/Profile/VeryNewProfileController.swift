//
//  VeryNewProfileController.swift
//  CoffeeBreakExample
//
//  Created by Soheil Ghanbari on 8/9/19.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import TinyConstraints
import LBTAComponents
import Firebase
import JGProgressHUD

class VeryNewProfileController: UIViewController {
    
    
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        var item = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogoutBarButtonItemTapped))
        return item
    }()
    
    @objc func handleLogoutBarButtonItemTapped() {
        let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            // MARK: FirebaseMagic - Log out
            let hud = JGProgressHUD(style: .light)
            FirebaseMagicService.showHud(hud, text: "Logging out...")
            FirebaseMagic.logout(completion: { (err) in
                FirebaseMagicService.dismiss(hud, afterDelay: nil, text: nil)
                
                if let err = err {
                    FirebaseMagicService.showAlert(style: .alert, title: "Logout Error", message: err.localizedDescription)
                    return
                }
                
                let controller = SignUpController()
                let navController = UINavigationController(rootViewController: controller)
                self.present(navController, animated: true, completion: nil)
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        FirebaseMagicService.showAlert(style: .actionSheet, title: nil, message: nil, actions: [logOutAction, cancelAction], completion: nil)
    }
    
    
    lazy var timeBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-settings.png"), style: .plain, target: self, action: #selector(timeBarButtonItemTapped))
    
    lazy var mainProfileStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var detailProfileStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var cityStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //let cityImageViewHeight : CGFloat = 88
    lazy var cityImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "city").withRenderingMode(.alwaysOriginal)
      //  iv.layer.cornerRadius = profileImageViewHeight / 2
       // iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var cityLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " CITY : "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var cityResultLable : UILabel = {
        let lable  = UILabel()
        lable.text = " "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var mobileNumberStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
   
    lazy var mobileNumberImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "phonelink_ring").withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    lazy var mobileNumberLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " Mobile Number : "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var mobileNumberResultLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    
    lazy var emailAddressStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
   
    lazy var emailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "email").withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    lazy var emailAddressLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " Email Address : "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var emailAddressResultLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var linkdinStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var linkdinImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "linkedin").withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    lazy var linkdinLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " Linkdin : "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var linkdinResultLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var facebookContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var facebookImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "facebook_new").withRenderingMode(.alwaysOriginal)
        iv.layer.cornerRadius = profileImageViewHeight / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var facebookLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " Facebook : "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var facebookResultLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " "
        lable.textAlignment = .left
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lable.numberOfLines = 0
        return lable
    }()
    
    
    let profileImageViewHeight : CGFloat = 88
    lazy var profileImageView: CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "profilePicture").withRenderingMode(.alwaysOriginal)
        iv.layer.cornerRadius = profileImageViewHeight / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    //The main Container on the right of the profile image which contains another stacks
    lazy var statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var statsDescriptionUserContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var descriptionUserLabel : UILabel = {
        let lable  = UILabel()
        lable.text = ""
        lable.textAlignment = .left
        lable.font = UIFont.systemFont(ofSize: 18)
        //  lable.font = UIFont.boldSystemFont(ofSize: 22)
        lable.textColor  = .black
        lable.numberOfLines = 3
        return lable
    }()
    
    lazy var statsFullNameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var fullNameLabel : UILabel = {
        let lable  = UILabel()
        lable.text = " "
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 22)
        lable.textColor  = .black
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var statsEditProfileContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var EditProfileButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Edit Profile", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.white])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.layer.borderColor = Setup.greyColor.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func editButtonTapped() {
        let userprofileController = userProfileEditController()
        userprofileController.userImage = profileImageView.image
        userprofileController.userCity = cityResultLable.text
        userprofileController.userMobileNumber = mobileNumberResultLabel.text
        userprofileController.userEmailAddress = emailAddressResultLabel.text
        userprofileController.userLinkdin = linkdinResultLabel.text
        userprofileController.userFacebook = facebookResultLabel.text
        navigationController?.pushViewController(userprofileController, animated: true)
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigation()
        setupViews()
        
        
        fetchCurrentUser() { (currentUser) in
            
            self.navigationItem.title = currentUser.username
            self.fullNameLabel.text = currentUser.name + " " + currentUser.lastName
            self.profileImageView.loadImage(urlString: currentUser.profileImageUrl)
            self.descriptionUserLabel.text = currentUser.description
            self.cityResultLable.text = currentUser.cityName
            self.mobileNumberResultLabel.text = currentUser.mobileNumber
            self.emailAddressResultLabel.text = currentUser.emailAddress
            self.linkdinResultLabel.text = currentUser.linkedin
            self.facebookResultLabel.text = currentUser.facebook
           // self.reloadAllOrders(completion: { (result) in
           //     print("Fetched user with result:", result)
          //  })
        }
    }
    
    
    
    func fetchCurrentUser(completion: @escaping (CurrentUser) -> ()) {
        // MARK: FirebaseMagic - Fetch current user
        guard let uid = FirebaseMagic.currentUserUid() else { return }
        let hud = JGProgressHUD(style: .light)
        FirebaseMagicService.showHud(hud, text: "Fetching user...")
        FirebaseMagic.fetchUser(withUid: uid) { (user, err) in
            if let err = err {
                FirebaseMagicService.dismiss(hud, afterDelay: nil, text: nil)
                FirebaseMagicService.showAlert(style: .alert, title: "Error fetching user", message: err.localizedDescription)
                return
            }
            guard let user = user else {
                FirebaseMagicService.dismiss(hud, afterDelay: nil, text: "Could not fetch...")
                return
            }
            print("Successfully fetched user:", user.username)
            
            FirebaseMagicService.dismiss(hud, afterDelay: nil, text: nil)
            
            completion(user)
        }
    }
    
    // MARK:- Setup Navigation
    fileprivate func setupNavigation(){
        title = "Profile"
        navigationItem.setRightBarButton(logoutBarButtonItem, animated: false)
       // CollectionView.showsVerticalScrollIndicator = false
    }
    
    // MARK:- Setup Views
    
    fileprivate func setupViews(){
        addViews()
        constraintViews()
    }

    fileprivate func addViews(){
        view.addSubview(containerView )
        view.addSubview(mainProfileStatsContainerView)
        view.addSubview(detailProfileStatsContainerView)
        view.addSubview(cityImageView)
        view.addSubview(cityLabel)
        view.addSubview(cityResultLable)
        view.addSubview(mobileNumberImageView)
        view.addSubview(mobileNumberLabel)
        view.addSubview(mobileNumberResultLabel)
        view.addSubview(emailImageView)
        view.addSubview(emailAddressLabel)
        view.addSubview(emailAddressResultLabel)
        view.addSubview(linkdinImageView)
        view.addSubview(linkdinLabel)
        view.addSubview(linkdinResultLabel)
        view.addSubview(facebookImageView)
        view.addSubview(facebookLabel)
        view.addSubview(facebookResultLabel)
        view.addSubview(statsContainerView) //the main stacks on the right of profile image
        view.addSubview(statsFullNameContainerView)
        view.addSubview(fullNameLabel)
        view.addSubview(statsEditProfileContainerView)
        view.addSubview(EditProfileButton)
        view.addSubview(statsDescriptionUserContainerView)
        view.addSubview(descriptionUserLabel)
        view.addSubview(profileImageView)
    }
    
    fileprivate func constraintViews(){
        
        containerView.height(1000)
        mainProfileStatsContainerView.height(230)
        detailProfileStatsContainerView.height(500)
        containerView.stack([mainProfileStatsContainerView,detailProfileStatsContainerView,UIView()], axis: .vertical, spacing: 0.5)
        statsContainerView.stack([statsFullNameContainerView,statsEditProfileContainerView,UIView()],
                                 axis: .vertical, spacing : 5)
        
        containerView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        
        profileImageView.top(to: mainProfileStatsContainerView, offset : 12)
        profileImageView.left(to: mainProfileStatsContainerView, offset : 12)
        profileImageView.width(profileImageViewHeight)
        profileImageView.height(profileImageViewHeight)
        
        statsContainerView.top(to: mainProfileStatsContainerView, offset : 12)
        statsContainerView.leftToRight(of: profileImageView, offset: 12)
        statsContainerView.right(to: mainProfileStatsContainerView , offset : -12)
        statsContainerView.height(profileImageViewHeight)
        
        statsDescriptionUserContainerView.left(to: mainProfileStatsContainerView, offset : 20)
        statsDescriptionUserContainerView.topToBottom(of: profileImageView, offset: 12)
        statsDescriptionUserContainerView.right(to: mainProfileStatsContainerView, offset : -12)
        statsDescriptionUserContainerView.height(100)
        
        statsFullNameContainerView.height(profileImageViewHeight * 0.63)
        statsEditProfileContainerView.height(profileImageViewHeight * 0.33)
        
        statsFullNameContainerView.width(95)
        
        fullNameLabel.edges(to: statsFullNameContainerView)
        EditProfileButton.edges(to: statsEditProfileContainerView)
        descriptionUserLabel.edges(to: statsDescriptionUserContainerView)
        
        cityStatsContainerView.height(80)
        mobileNumberStatsContainerView.height(80)
        emailAddressStatsContainerView.height(80)
        linkdinStatsContainerView.height(80)
        facebookContainerView.height(80)
        
        detailProfileStatsContainerView.stack([cityStatsContainerView,
                                         mobileNumberStatsContainerView,
                                         emailAddressStatsContainerView,
                                         linkdinStatsContainerView,
                                         facebookContainerView],
                                        axis: .vertical ,spacing: 0.5)
        
        cityImageView.top(to: cityStatsContainerView, offset : 12)
        cityImageView.left(to: cityStatsContainerView, offset : 12)
        cityImageView.width(50)
        cityImageView.height(50)
        cityLabel.top(to: cityStatsContainerView, offset : 25)
        cityLabel.leftToRight(of: cityImageView, offset: 0)
        cityLabel.right(to: cityStatsContainerView )
        
//        cityResultLable.edges(to: cityStatsContainerView, insets:TinyEdgeInsets(top:5,left:80,bottom:0,right:0))
        cityResultLable.top(to: cityStatsContainerView,offset: -7)
        cityResultLable.left(to: cityStatsContainerView, offset: 135)
        cityResultLable.right(to: cityStatsContainerView )
        cityResultLable.bottom(to: cityStatsContainerView )
        
        mobileNumberImageView.top(to: mobileNumberStatsContainerView, offset : 5)
        mobileNumberImageView.left(to: mobileNumberStatsContainerView, offset : 12)
        mobileNumberImageView.width(50)
        mobileNumberImageView.height(50)
        mobileNumberLabel.top(to: mobileNumberStatsContainerView, offset : 25)
        mobileNumberLabel.leftToRight(of: mobileNumberImageView, offset: 0)
        mobileNumberLabel.right(to: mobileNumberStatsContainerView )
        mobileNumberResultLabel.edges(to: mobileNumberStatsContainerView, insets:TinyEdgeInsets(top:-6,left:230,bottom:0,right:0))
        
        emailImageView.top(to: emailAddressStatsContainerView, offset : 5)
        emailImageView.left(to: emailAddressStatsContainerView, offset : 12)
        emailImageView.width(50)
        emailImageView.height(50)
        emailAddressLabel.top(to: emailAddressStatsContainerView, offset : 25)
        emailAddressLabel.leftToRight(of: emailImageView, offset: 0)
        emailAddressLabel.right(to: emailAddressStatsContainerView )
        emailAddressResultLabel.edges(to: emailAddressStatsContainerView, insets:TinyEdgeInsets(top:0,left:230,bottom:0,right:0))
        
        linkdinImageView.top(to: linkdinStatsContainerView, offset : 5)
        linkdinImageView.left(to: linkdinStatsContainerView, offset : 12)
        linkdinImageView.width(50)
        linkdinImageView.height(50)
        linkdinLabel.top(to: linkdinStatsContainerView, offset : 25)
        linkdinLabel.leftToRight(of: linkdinImageView, offset: 0)
        linkdinLabel.right(to: linkdinStatsContainerView )
        linkdinResultLabel.edges(to: linkdinStatsContainerView, insets:TinyEdgeInsets(top:-6,left:170,bottom:0,right:0))
        
        facebookImageView.top(to: facebookContainerView, offset : 5)
        facebookImageView.left(to: facebookContainerView, offset : 12)
        facebookImageView.width(50)
        facebookImageView.height(50)
        facebookLabel.top(to: facebookContainerView, offset : 25)
        facebookLabel.leftToRight(of: facebookImageView, offset: 0)
        facebookLabel.right(to: facebookContainerView )
        facebookResultLabel.edges(to: facebookContainerView, insets:TinyEdgeInsets(top:-110,left:190,bottom:0,right:0))
        
        
    }
    
    //MARK :- Handlers
    @objc fileprivate func timeBarButtonItemTapped(){
        print("Time bar item Tapped ")
    }
}
