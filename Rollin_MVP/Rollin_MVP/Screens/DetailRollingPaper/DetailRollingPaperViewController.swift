//
//  DetailRollingPaperViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/11.
//

import UIKit

final class DetailRollingPaperViewController: UIViewController {
    
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
    //TODO: 후에 글, 사진 포스트로 변경 예정
    private var post = [UIColor.blue, UIColor.red]
    var PostRollingPaperModel: PostRollingPaperModel?
    var message: String? = ""
    var from: String? = ""
    var image: UIImage? = UIImage()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "상세보기"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewFlowLayout()
        setCollectionView()
        setPostLayout()
        setButton()
    }
}

extension DetailRollingPaperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.post.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPostCollectionViewCell.className, for: indexPath) as! DetailPostCollectionViewCell
        if indexPath.row == 1 {
            cell.isPhoto = true
        }
        cell.message.text = PostRollingPaperModel?.commentString
        cell.image.image = PostRollingPaperModel?.image
        cell.detailPostView.backgroundColor = PostRollingPaperModel?.color
        return cell
    }
}

extension DetailRollingPaperViewController: UICollectionViewDelegateFlowLayout {
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

private extension DetailRollingPaperViewController {
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
        collectionView.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.className)
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = LayoutValue.collectionViewContentInset
        collectionView.decelerationRate = .fast
    }
    
    func setPostLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.dismissButton)
        NSLayoutConstraint.activate([
            self.dismissButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 40),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: LayoutValue.postSize.height),
            self.collectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 22),
        ])
        
        pageControllerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControllerStackView)
        NSLayoutConstraint.activate([
            pageControllerStackView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 15),
            pageControllerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageControllerStackView.heightAnchor.constraint(equalToConstant: 8),
            pageControllerStackView.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
        pageControllerFirstDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerFirstDotView.topAnchor.constraint(equalTo: self.pageControllerStackView.topAnchor),
            pageControllerFirstDotView.leadingAnchor.constraint(equalTo: self.pageControllerStackView.leadingAnchor),
            pageControllerFirstDotView.bottomAnchor.constraint(equalTo: self.pageControllerStackView.bottomAnchor),
            pageControllerFirstDotView.heightAnchor.constraint(equalToConstant: 8),
            pageControllerFirstDotView.widthAnchor.constraint(equalToConstant: 8),
        ])
        
        pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        pageControllerSecondDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerSecondDotView.topAnchor.constraint(equalTo: self.pageControllerStackView.topAnchor),
            pageControllerSecondDotView.trailingAnchor.constraint(equalTo: self.pageControllerStackView.trailingAnchor),
            pageControllerSecondDotView.bottomAnchor.constraint(equalTo: self.pageControllerStackView.bottomAnchor),
            pageControllerSecondDotView.heightAnchor.constraint(equalToConstant: 8),
            pageControllerSecondDotView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func setButton() {
        dismissButton.addTarget(self, action: #selector(touchUpInsideToDismiss), for: .touchUpInside)
    }
    
    @objc
    func touchUpInsideToDismiss() {
        self.dismiss(animated: true)
    }
}
