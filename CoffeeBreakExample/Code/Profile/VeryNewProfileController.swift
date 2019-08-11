//
//  VeryNewProfileController.swift
//  CoffeeBreakExample
//
//  Created by Soheil Ghanbari on 8/9/19.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import TinyConstraints

class VeryNewProfileController: UIViewController {
    
    // MARK:- Properties
    
    // MARK:- Views
    
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
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = .black
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
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = .black
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
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = .black
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
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = .black
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
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        lable.textColor  = .black
        lable.numberOfLines = 0
        return lable
    }()
    
    let profileImageViewHeight : CGFloat = 88
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
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
        lable.text = """
        Joined in March 2019
        Traveller Rating
        Each time I go to Buenos Aires using Grabr.
        """
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
        lable.text = " SOHEIL GHANBARI "
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
        
        
//        userprofileController.userImage = productimage
//        userprofileController.userFirstName = productName
//        userprofileController.userLastName = deliverFromTextField.text
//        userprofileController.userCity = deliverToTextField.text
//        userprofileController.userMobileNumber = deliverydate.text
//        userprofileController.userEmailAddress
//        userprofileController.userLinkdin
        
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
    }
    
    // MARK:- Setup Navigation
    fileprivate func setupNavigation(){
        title = "Profile"
        self.navigationItem.setLeftBarButton(timeBarButtonItem, animated: false)
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
        view.addSubview(mobileNumberImageView)
        view.addSubview(mobileNumberLabel)
        view.addSubview(emailImageView)
        view.addSubview(emailAddressLabel)
        view.addSubview(linkdinImageView)
        view.addSubview(linkdinLabel)
        view.addSubview(facebookImageView)
        view.addSubview(facebookLabel)
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
        detailProfileStatsContainerView.height(400)
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
        cityLabel.leftToRight(of: cityImageView, offset: 12)
        cityLabel.right(to: cityStatsContainerView )
        
        mobileNumberImageView.top(to: mobileNumberStatsContainerView, offset : 5)
        mobileNumberImageView.left(to: mobileNumberStatsContainerView, offset : 12)
        mobileNumberImageView.width(50)
        mobileNumberImageView.height(50)
        mobileNumberLabel.top(to: mobileNumberStatsContainerView, offset : 25)
        mobileNumberLabel.leftToRight(of: mobileNumberImageView, offset: 12)
        mobileNumberLabel.right(to: mobileNumberStatsContainerView )
        
        emailImageView.top(to: emailAddressStatsContainerView, offset : 5)
        emailImageView.left(to: emailAddressStatsContainerView, offset : 12)
        emailImageView.width(50)
        emailImageView.height(50)
        emailAddressLabel.top(to: emailAddressStatsContainerView, offset : 25)
        emailAddressLabel.leftToRight(of: emailImageView, offset: 12)
        emailAddressLabel.right(to: emailAddressStatsContainerView )
        
        linkdinImageView.top(to: linkdinStatsContainerView, offset : 5)
        linkdinImageView.left(to: linkdinStatsContainerView, offset : 12)
        linkdinImageView.width(50)
        linkdinImageView.height(50)
        linkdinLabel.top(to: linkdinStatsContainerView, offset : 25)
        linkdinLabel.leftToRight(of: linkdinImageView, offset: 12)
        linkdinLabel.right(to: linkdinStatsContainerView )
        
        facebookImageView.top(to: facebookContainerView, offset : 5)
        facebookImageView.left(to: facebookContainerView, offset : 12)
        facebookImageView.width(50)
        facebookImageView.height(50)
        facebookLabel.top(to: facebookContainerView, offset : 25)
        facebookLabel.leftToRight(of: facebookImageView, offset: 12)
        facebookLabel.right(to: facebookContainerView )
        
        
    }
    
    //MARK :- Handlers
    @objc fileprivate func timeBarButtonItemTapped(){
        print("Time bar item Tapped ")
    }
}
