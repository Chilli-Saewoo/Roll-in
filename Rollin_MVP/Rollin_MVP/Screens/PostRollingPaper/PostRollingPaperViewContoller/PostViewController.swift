//
//  ReadRollingViewController.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

class PostViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: [PostRollingPaperModel] = []
    private lazy var titleMessageLabel = UILabel()
    private let writeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        configurePostViewController()
        setupPostViewControllerLayout()
        setTitleMessageLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupDataSource() {
        dataSource = PostRollingPaperModel.getMock()
    }
}

private extension PostViewController {
    
    private func configurePostViewController() {
        let collectionViewLayout = PostRollingPaperLayout()
        collectionViewLayout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostRollingPaperCollectionViewCell.self, forCellWithReuseIdentifier: PostRollingPaperCollectionViewCell.id)
    }

    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.setTextWithLineHeight(text: "Key의 롤링페이퍼", lineHeight: 40)
        titleMessageLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleMessageLabel.numberOfLines = 0
    }
    
    func setupWriteButtonLayout() {
        view.addSubview(writeButton)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
    }
    
    private func setupPostViewControllerLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension PostViewController: PostRollingPaperLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageHeight = dataSource[indexPath.item].image.size.height
        let labelHeight = dataSource[indexPath.item].commentString.heightWithConstrainedWidth(width: 100, font: UIFont.systemFont(ofSize: 15, weight: .bold))
        print(imageHeight)
        print(labelHeight)
        return imageHeight + labelHeight + 40
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(dataSource.count)
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostRollingPaperCollectionViewCell.id, for: indexPath)
        if let cell = cell as? PostRollingPaperCollectionViewCell {
            cell.myModel = dataSource[indexPath.item]
        }
        return cell
    }
}

