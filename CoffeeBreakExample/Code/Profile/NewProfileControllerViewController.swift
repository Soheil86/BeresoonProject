//
//  NewProfileControllerViewController.swift
//  CoffeeBreakExample
//
//  Created by Soheil Ghanbari on 8/9/19.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import TinyConstraints

class NewProfileControllerViewController: UIViewController {

    // MARK:- Properties
    
    // MARK:- Views
    
    lazy var timeBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-settings.png"), style: .plain, target: self, action: #selector(timeBarButtonItemTapped))
    
    lazy var businessStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var businessStatsLabel : UILabel = {
       let lable  = UILabel()
        lable.text = " 61 profile visits in the last 7 days"
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor  = .lightGray
        return lable
    }()
    
    lazy var profileStatsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    let profileImageViewHeight : CGFloat = 88
    lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "icons8-user.png").withRenderingMode(.alwaysOriginal)
        iv.layer.cornerRadius = profileImageViewHeight / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let plusImageViewHeight : CGFloat = 22
    lazy var plusImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "icons8-settings-1").withRenderingMode(.alwaysOriginal)
        iv.layer.cornerRadius = plusImageViewHeight / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var statsNumbersContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var statsNumber1ContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var statsNumber1Label : UILabel = {
        let lable  = UILabel()
        lable.text = """
        838
        Posts
        """
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor  = .black
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var statsNumber2ContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var statsNumber2Label : UILabel = {
        let lable  = UILabel()
        lable.text = """
        13K
        Followers
        """
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor  = .black
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var statsNumber3ContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var statsNumber3Label : UILabel = {
        let lable  = UILabel()
        lable.text = """
        7.525
        Following
        """
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor  = .black
        lable.numberOfLines = 0
        return lable
    }()
    
    lazy var statsButtonsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK:- Life Cycle
    
    
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
        view.addSubview(businessStatsContainerView)
        view.addSubview(businessStatsLabel)
        view.addSubview(profileStatsContainerView)
        view.addSubview(profileImageView)
        view.addSubview(statsContainerView)
        view.addSubview(statsNumbersContainerView)
        view.addSubview(statsNumber1Label)
        view.addSubview(statsNumber2Label)
        view.addSubview(statsNumber3Label)
        view.addSubview(statsButtonsContainerView)
        view.addSubview(plusImageView )
    }
    
    fileprivate func constraintViews(){
        
        containerView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        
        containerView.height(1000)
        businessStatsContainerView.height(50)
        profileStatsContainerView.height(400)
        
        containerView.stack([businessStatsContainerView,profileStatsContainerView,UIView()], axis: .vertical, spacing: 0.5)
        
        businessStatsLabel.edges(to: businessStatsContainerView,
                                 insets: TinyEdgeInsets(top: 12
                                    , left: 12
                                    , bottom: 12
                                    , right: 12))
        
        profileImageView.top(to: profileStatsContainerView, offset : 12)
        profileImageView.left(to: profileStatsContainerView, offset : 12)
        profileImageView.width(profileImageViewHeight)
        profileImageView.height(profileImageViewHeight)
        
        plusImageView.bottom(to: profileImageView)
        plusImageView.right(to: profileImageView)
        plusImageView.width(plusImageViewHeight)
        plusImageView.height(plusImageViewHeight)
        
        statsContainerView.top(to: profileStatsContainerView, offset : 12)
        statsContainerView.leftToRight(of: profileImageView, offset : 12)
        statsContainerView.right(to: profileStatsContainerView, offset : -12)
        statsContainerView.height(profileImageViewHeight)
        
        statsNumbersContainerView.height(profileImageViewHeight * 0.63)
        statsButtonsContainerView.height(profileImageViewHeight * 0.33)
        
        statsContainerView.stack([statsNumbersContainerView,statsButtonsContainerView,UIView()],
                                 axis: .vertical, spacing : 5)
        
        statsNumber1ContainerView.width(95)
        statsNumber2ContainerView.width(95)
        statsNumber3ContainerView.width(95 )
        
        statsNumbersContainerView.stack([statsNumber1ContainerView,
                                         statsNumber2ContainerView,
                                         statsNumber3ContainerView],
                                         axis: .horizontal )
        
        statsNumber1Label.edges(to: statsNumber1ContainerView)
        statsNumber2Label.edges(to: statsNumber2ContainerView)
        statsNumber3Label.edges(to: statsNumber3ContainerView)
        
    }
    
    //MARK :- Handlers
    @objc fileprivate func timeBarButtonItemTapped(){
        print("Time bar item Tapped ")
    }
    
}
