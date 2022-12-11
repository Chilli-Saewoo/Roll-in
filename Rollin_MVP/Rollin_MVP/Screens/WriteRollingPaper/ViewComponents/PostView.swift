//
//  PostView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

protocol PostViewDelegate: AnyObject {
    func changePostColor(selectedTextColor: UIColor, selectedBgColor: UIColor)
    
    func changePostTheme(theme: String)
    
    func setTextCount(textCount: Int)
}

final class PostView: UIView {
    
    enum LayoutValue {
        static let postSize = CGSize(width: UIScreen.main.bounds.width - 76, height: (UIScreen.main.bounds.height / 2) - 114)
        static let postSpacing = 38.0
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.postSize.width) / 2.0
        }
        static var collectionViewContentInset = UIEdgeInsets(top: 5, left: insetX, bottom: 0, right: insetX)
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
    
    var writerNickname: String = ""
    
//    var isPhotoAdded: Bool = false
    var isTextEdited: Bool = false
    var isPublic: Bool = true
    
    weak var delegate: WriteRollingPaperViewDelegate?
    
    let privateButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.setTitle(" 공개", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setImage(UIImage(systemName: "lock.open"), for: .normal)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12)
        button.setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/200"
        return label
    }()
    
//    let emptyImageButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("사진 추가하기", for: .normal)
//        button.setTitleColor(.systemBlack, for: .normal)
//        button.setImage(UIImage(systemName: "plus"), for: .normal)
//        button.tintColor = .systemBlack
//        button.backgroundColor = .white
//        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 4
//        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        return button
//    }()
//
//    let addedImageButton: UIButton = {
//        let button = UIButton()
//        button.contentMode = .scaleAspectFit
//        button.layer.cornerRadius = 4
//        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        return button
//    }()
    
    var postTextCollectionViewCell: PostTextCollectionViewCell = PostTextCollectionViewCell(frame: CGRect())
    
    private let pageControllerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let pageControllerFirstDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let pageControllerSecondDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPostLayout()
        setCollectionView()
        setCollectionViewFlowLayout()
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButton() {
        privateButton.addTarget(self, action: #selector(touchUpInsideToSetPrivate), for: .touchUpInside)
    }
    
    @objc
    func touchUpInsideToSetPrivate() {
        isPublic.toggle()
        if isPublic {
            privateButton.setTitle(" 공개", for: .normal)
            privateButton.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
            privateButton.backgroundColor = .black
            privateButton.tintColor = .white
            privateButton.setTitleColor(.white, for: .normal)
        } else {
            privateButton.setTitle(" 비공개", for: .normal)
            privateButton.setImage(UIImage(systemName: "lock.fill"), for: .normal)
            privateButton.backgroundColor = .white
            privateButton.tintColor = .black
            privateButton.setTitleColor(.black, for: .normal)
            
        }
    }
    
    private func setupPostLayout() {
        addSubview(privateButton)
        privateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateButton.topAnchor.constraint(equalTo: topAnchor),
            privateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            privateButton.widthAnchor.constraint(equalToConstant: 62),
            privateButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        addSubview(textCountLabel)
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textCountLabel.centerYAnchor.constraint(equalTo: privateButton.centerYAnchor),
            textCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            textCountLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: privateButton.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: LayoutValue.postSize.width)
        ])
        
        addSubview(pageControllerStackView)
        pageControllerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControllerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControllerStackView.widthAnchor.constraint(equalToConstant: 25),
            pageControllerStackView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
        pageControllerFirstDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerFirstDotView.topAnchor.constraint(equalTo: pageControllerStackView.topAnchor),
            pageControllerFirstDotView.leadingAnchor.constraint(equalTo: pageControllerStackView.leadingAnchor),
            pageControllerFirstDotView.bottomAnchor.constraint(equalTo: pageControllerStackView.bottomAnchor),
            pageControllerFirstDotView.widthAnchor.constraint(equalToConstant: 8)
        ])
        
        pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        pageControllerSecondDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerSecondDotView.topAnchor.constraint(equalTo: pageControllerStackView.topAnchor),
            pageControllerSecondDotView.trailingAnchor.constraint(equalTo: pageControllerStackView.trailingAnchor),
            pageControllerSecondDotView.bottomAnchor.constraint(equalTo: pageControllerStackView.bottomAnchor),
            pageControllerSecondDotView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
    
//    func setupAddedImageButtonLayout() {
//        addSubview(addedImageButton)
//        addedImageButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            addedImageButton.topAnchor.constraint(equalTo: textView.bottomAnchor),
//            addedImageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            addedImageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            addedImageButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            addedImageButton.heightAnchor.constraint(equalToConstant: 200)
//        ])
//    }
    
    private func checkTextLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isLimit = text.count + newText.count <= limit
        return isLimit
    }
}

extension PostView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            self.postTextCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostTextCollectionViewCell.className, for: indexPath) as! PostTextCollectionViewCell
//            let textColor = getTextColor(backgroundColorString: post.postTheme)
//            cell.message.text = post.message
//            cell.message.textColor = textColor
//            cell.detailPostView.backgroundColor = hexStringToUIColor(hex: post.postTheme)
            self.postTextCollectionViewCell.fromLabel.text = "From. \(writerNickname)"
            self.postTextCollectionViewCell.postViewDelegate = self
            self.postTextCollectionViewCell.writeRollingPaperViewDelegate = delegate
//            cell.from.textColor = textColor
            return self.postTextCollectionViewCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCollectionViewCell.className, for: indexPath) as! PostImageCollectionViewCell
//            cell.imageView.image = image ?? UIImage()
            return cell
        }
    }
}

extension PostView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = LayoutValue.postSize.width + LayoutValue.postSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        if index == 0.0 {
            pageControllerFirstDotView.backgroundColor = .black
            pageControllerSecondDotView.backgroundColor = .lightGray
            pageControllerFirstDotView.removeFromSuperview()
            pageControllerSecondDotView.removeFromSuperview()
            pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
            pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        } else if index == 1.0 {
            pageControllerFirstDotView.backgroundColor = .lightGray
            pageControllerSecondDotView.backgroundColor = .black
            pageControllerFirstDotView.removeFromSuperview()
            pageControllerSecondDotView.removeFromSuperview()
            pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
            pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        }
    }
}

extension PostView {
    func setCollectionViewFlowLayout() {
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize = LayoutValue.postSize
        collectionViewFlowLayout.minimumLineSpacing = LayoutValue.postSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = 0
    }
    
    func setCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(PostTextCollectionViewCell.self, forCellWithReuseIdentifier: PostTextCollectionViewCell.className)
        collectionView.register(PostImageCollectionViewCell.self, forCellWithReuseIdentifier: PostImageCollectionViewCell.className)
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = LayoutValue.collectionViewContentInset
        collectionView.decelerationRate = .fast
    }
    
    func stringToImage(imageString: String) -> UIImage {
        switch imageString {
        case "mistletoe" :
            return UIImage(named: "mistletoe") ?? UIImage()
        case "light" :
            return UIImage(named: "light") ?? UIImage()
        case "orangeStripe" :
            return UIImage(named: "orangeStripe") ?? UIImage()
        case "redStripe" :
            return UIImage(named: "redStripe") ?? UIImage()
        case "deer" :
            return UIImage(named: "deer") ?? UIImage()
        case "snowman" :
            return UIImage(named: "snowman") ?? UIImage()
        case "gingerBread" :
            return UIImage(named: "gingerBread") ?? UIImage()
        case "santa" :
            return UIImage(named: "santa") ?? UIImage()
        default:
            return UIImage()
        }
    }
}

extension PostView: PostViewDelegate {
    func changePostColor(selectedTextColor: UIColor, selectedBgColor: UIColor) {
        self.postTextCollectionViewCell.textView.textColor = selectedTextColor
        self.postTextCollectionViewCell.fromLabel.textColor = selectedTextColor
        self.postTextCollectionViewCell.textView.backgroundColor = selectedBgColor
    }
    
    func changePostTheme(theme: String) {
        let image = stringToImage(imageString: theme)
        self.postTextCollectionViewCell.imageView.image = image
    }
    
    func setTextCount(textCount: Int) {
        textCountLabel.text = "\(textCount)/200"
    }
}
