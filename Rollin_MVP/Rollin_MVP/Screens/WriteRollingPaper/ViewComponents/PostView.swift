//
//  PostView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

//protocol WriteRollingPaperViewControllerDelegate: AnyObject {
//    func activeConfirmButton()
//    
//    func inactiveConfirmButton()
//}

protocol PostViewDelegate: AnyObject {
    func changePostColor(selectedTextColor: UIColor, selectedBgColor: UIColor)
    
    func setTextCount(textCount: Int)
}

final class PostView: UIView {
    
    private enum LayoutValue {
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
    
//    weak var delegate: WriteRollingPaperViewControllerDelegate?
    
//    let privateSwitch: UISwitch = {
//        let privateSwitch = UISwitch()
//        privateSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        privateSwitch.onTintColor = .systemBlack
//        privateSwitch.setOn(true, animated: false)
//        return privateSwitch
//    }()
    
//    private let privateSwitchTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "그룹내 공개"
//        label.font = .preferredFont(forTextStyle: .footnote)
//        return label
//    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/200"
        return label
    }()
    
//    let textView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .bgRed
//        textView.textColor = .textRed
//        textView.tintColor = .textRed
//        textView.font = .preferredFont(forTextStyle: .body)
//        textView.textContainerInset = UIEdgeInsets(top: 13, left: 12, bottom: 36, right: 12)
//        textView.text = "글과 사진을 모두 등록해야 업로드 됩니다"
//        textView.layer.cornerRadius = 4
//        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        textView.autocorrectionType = .no
//        textView.spellCheckingType = .no
//        return textView
//    }()
//
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
//
//    let fromLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        label.textColor = .textRed
//        return label
//    }()
    
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPostLayout() {
        addSubview(textCountLabel)
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textCountLabel.topAnchor.constraint(equalTo: topAnchor),
            textCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            textCountLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
//        addSubview(privateSwitch)
//        privateSwitch.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            privateSwitch.centerYAnchor.constraint(equalTo: textCountLabel.centerYAnchor),
//            privateSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
//        ])
//
//        addSubview(privateSwitchTitleLabel)
//        privateSwitchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            privateSwitchTitleLabel.centerYAnchor.constraint(equalTo: privateSwitch.centerYAnchor),
//            privateSwitchTitleLabel.trailingAnchor.constraint(equalTo: privateSwitch.leadingAnchor, constant: 0),
//            privateSwitchTitleLabel.heightAnchor.constraint(equalToConstant: 16)
//        ])
//
//        addSubview(textView)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            textView.topAnchor.constraint(equalTo: textCountLabel.bottomAnchor, constant: 8),
//            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            textView.heightAnchor.constraint(equalToConstant: 164),
//        ])
//
//        addSubview(emptyImageButton)
//        emptyImageButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            emptyImageButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
//            emptyImageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            emptyImageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            emptyImageButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            emptyImageButton.heightAnchor.constraint(equalToConstant: 66)
//        ])
//
//        addSubview(fromLabel)
//        fromLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            fromLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -8),
//            fromLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12),
//        ])
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: textCountLabel.bottomAnchor, constant: 4),
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


extension PostView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return self.checkTextLimit(existingText: textView.text,
                                  newText: text,
                                  limit: 200)
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        textCountLabel.text = "\(textView.text.count)/100"
//        if isTextEdited && isPhotoAdded {
//            delegate?.activeConfirmButton()
//        } else {
//            delegate?.inactiveConfirmButton()
//        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if !isTextEdited {
//            let cell = collectionView.cellForItem(at: index)
//            isTextEdited = true
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let textWithoutWhiteSpace = textView.text.trimmingCharacters(in: .whitespaces)
//        if isTextEdited && textWithoutWhiteSpace == "" {
//            textView.text = "글과 사진을 모두 등록해야 업로드 됩니다"
//            textCountLabel.text = "0/100"
//            isTextEdited = false
//            delegate?.inactiveConfirmButton()
//        }
    }
}

extension PostView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let post = post else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostTextCollectionViewCell.className, for: indexPath) as! PostTextCollectionViewCell
//            let textColor = getTextColor(backgroundColorString: post.postTheme)
//            cell.message.text = post.message
//            cell.message.textColor = textColor
//            cell.detailPostView.backgroundColor = hexStringToUIColor(hex: post.postTheme)
            cell.fromLabel.text = "From. \(writerNickname)"
            cell.delegate = self
//            cell.from.textColor = textColor
            return cell
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
}

extension PostView: PostViewDelegate {
    func changePostColor(selectedTextColor: UIColor, selectedBgColor: UIColor) {
    }
    
    func setTextCount(textCount: Int) {
        textCountLabel.text = "\(textCount)/200"
    }
}
