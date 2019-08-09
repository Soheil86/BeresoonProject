//
//
//import UIKit
//import LBTATools
//
//struct Category {
//    let categotyImageName,userName,text: String
//}
//
//class CategoryCell: LBTAListCell<Category> {
//
//    var imageView = UIImageView()
//
//    let nameLable = UILabel(text: "User name", font: .boldSystemFont(ofSize: 16))
//    let messageLable = UILabel(text: "Hey Girl Whatsup there?", font: .systemFont(ofSize: 14), textColor: .gray)
//
//    override var item: Category!{
//        didSet{
//            imageView.image = UIImage(named: item.categotyImageName)
//            nameLable.text = item.userName
//            messageLable.text = item.text
//        }
//    }
//
//    override func setupViews() {
//        super.setupViews()
//
//        imageView.contentMode = .scaleAspectFill
//
//        hstack(
//            imageView.withWidth(64).withHeight(64),
//               stack(nameLable,messageLable,spacing: 4),
//               spacing: 12,
//               alignment: .center
//               ).withMargins(.allSides(16))
//
//        addSeparatorView(leadingAnchor: nameLable.leadingAnchor)
//    }
//}
//
//class ProductCell: LBTAListCell<Product> {
//
//    let imageView = UIImageView(backgroundColor: .gray)
//    let priceLable = UILabel(text: "User name", font: .boldSystemFont(ofSize: 16))
//    let descriptionLable = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .systemFont(ofSize: 14), textColor: .gray, numberOfLines: 2)
//
//    override var item: Product! {
//        didSet {
//            priceLable.text = item.price
//            imageView.image = UIImage(named: item.imageProduct)
//            descriptionLable.text = item.description
//        }
//    }
//
//    override func setupViews() {
//        super.setupViews()
//
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 0.5
//        imageView.layer.cornerRadius = 64 / 2
//
//        hstack(imageView.withWidth(64).withHeight(64),
//               stack(priceLable, descriptionLable, spacing: 4),
//               spacing: 12,
//               alignment: .center).withMargins(.allSides(16))
//
//        addSeparatorView(leadingAnchor: priceLable.leadingAnchor)
//    }
//}
//
//class MatchesController: LBTAListController<ProductCell,Product > {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        items = [
//            .init(imageProduct: "shoe-2538424_640",
//                  price: "49.00",
//                  description: "Let's go to Mcdonalds and grab a sandwich girl."),
//
//            .init(imageProduct: "model-2911330_640",
//                  price: "69.99",
//                  description: "Let's go to Mcdonalds and grab a sandwich girl."),
//
//            .init(imageProduct: "iphone-410324_640",
//                  price: "114.16",
//                  description: "Let's go to Mcdonalds and grab a sandwich girl."),
//
//            .init(imageProduct: "clothing-store-984396_640",
//                  price: "78.50",
//                  description: "Let's go to Mcdonalds and grab a sandwich girl.")
//        ]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return .init(width: 100, height: view.frame.height)
//    }
//}
//
//class Header: UICollectionReusableView {
//
//    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 14), textColor: #colorLiteral(red: 0.9826290011, green: 0.2883806527, blue: 0.399230808, alpha: 1))
//
//    let matchesController = MatchesController(scrollDirection: .horizontal)
//
//    let addOrderManuallybutton = UIButton(title: "ADD ORDER MANUALLY"
//        , titleColor: .white
//        , font: .boldSystemFont(ofSize: 16)
//        , backgroundColor: #colorLiteral(red: 0.2883880436, green: 0.5055884719, blue: 0.9490465522, alpha: 1)
//        , target: self)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        stack(hstack(newMatchesLabel).padLeft(16),
//              matchesController.view,
//              hstack(addOrderManuallybutton).padLeft(16).padRight(16),
//              spacing: 22).padTop(16).padBottom(20)
//
//        addOrderManuallybutton.layer.cornerRadius = 5
//        addOrderManuallybutton.constrainHeight(40)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError()
//    }
//
//}
//
//class OrderListController: LBTAListHeaderController<ProductCell,Product,Header>
//{
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: view.frame.width, height: 270)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.title = "ORDERS "
//
//        items=[
//            .init(userProfileImageName: "shoe-2538424_640", userName: "NIKE", text: "657556"),
//            .init(userProfileImageName: "model-2911330_640", userName: "ADIDAS", text: "657556"),
//            .init(userProfileImageName: "iphone-410324_640", userName: "REEDBOK", text: "657556")
//        ]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return .init(width: view.frame.width, height: 100)
//    }
//}
//
//
//
//
