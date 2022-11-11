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
        cell.setBackgroundColor(color: self.post[indexPath.item])
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
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        //TODO: 추후 className으로 id 값 설정하는 extension 차용
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
            self.dismissButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
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
    }
    
    func setButton() {
        dismissButton.addTarget(self, action: #selector(touchUpInsideToDismiss), for: .touchUpInside)
    }
    
    @objc
    func touchUpInsideToDismiss() {
        self.dismiss(animated: true)
    }
}
