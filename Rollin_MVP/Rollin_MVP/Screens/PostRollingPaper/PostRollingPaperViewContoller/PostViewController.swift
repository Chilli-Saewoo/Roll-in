//
//  ReadRollingViewController.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift

class PostViewController: UIViewController, UISheetPresentationControllerDelegate {

    var collectionView: UICollectionView!
    var dataSource: [PostRollingPaperModel] = []
    private lazy var titleMessageLabel = UILabel()
    private lazy var writeButton = UIButton()
    private lazy var plusButton = UIButton()
    var rollingPaperInfo: RollingPaperInfo?
    var groupNickname: String?
    var groupId: String?
    var receiverUserId: String?
    var posts: [RollingPaperPostData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePostViewController()
        setupPostViewControllerLayout()
        fetchAllPosts()
        setTitleMessageLayout()
        setWriteButtonLayout()
    }
    
    
    private func setupDataSource() {
        for post in posts {
            var image = UIImage()
            FirebaseStorageManager.downloadImage(urlString: post.image) { uiImage in
                guard let uiImage = uiImage else { return }
                image = uiImage
                let color = UIColor(hex: "#\(post.postTheme)")
                self.dataSource.append(PostRollingPaperModel(color: color, commentString: post.message, image: image.resizeImage(newWidth: 170) ?? UIImage(), contentHeightSize: CGFloat(arc4random_uniform(500))))
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchAllPosts() {
        Task {
            let posts = try await fetchPosts()
            self.posts = posts
            setupDataSource()
        }
    }
    
    @objc private func didTapButton() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteRollingPaperViewController") else {return}
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    func setWriteButtonLayout() {
        if receiverUserId != UserDefaults.standard.string(forKey: "uid") {
            view.addSubview(writeButton)
            writeButton.translatesAutoresizingMaskIntoConstraints = false
            var writeButtonImage = UIImage(systemName: "plus")
            writeButtonImage = writeButtonImage?.resizeImage(newWidth: 22)
            writeButton.setImage(writeButtonImage, for: .normal)
            writeButton.tintColor = .systemBlack
            writeButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                writeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
                writeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            ])
        }
        
    }

    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        guard let groupNickname = groupNickname else { return }
        titleMessageLabel.setTextWithLineHeight(text: "\(groupNickname)의 롤링페이퍼", lineHeight: 40)
        titleMessageLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleMessageLabel.numberOfLines = 0
    }
    
    private func setupPostViewControllerLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func presentDetailViewHalfModal() {
        
        let rollingPaperDetailViewController = DetailRollingPaperViewController()
        rollingPaperDetailViewController.view.backgroundColor = .white
        rollingPaperDetailViewController.modalPresentationStyle = .pageSheet
        
        if let halfModal = rollingPaperDetailViewController.sheetPresentationController {
            halfModal.preferredCornerRadius = 10
            halfModal.detents = [.medium()]
            halfModal.delegate = self
            halfModal.prefersGrabberVisible = true
        }
        
        present(rollingPaperDetailViewController, animated: true, completion: nil)
    }
}

extension PostViewController: PostRollingPaperLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageHeight = dataSource[indexPath.item].image.size.height
        let labelHeight = dataSource[indexPath.item].commentString.heightWithConstrainedWidth(width: UIScreen.main.bounds.width/2-55, font: UIFont.systemFont(ofSize: 15, weight: .medium))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailViewHalfModal()
    }
}


private extension PostViewController {
    func fetchPosts() async throws -> [RollingPaperPostData] {
        let db = FirebaseFirestore.Firestore.firestore()
        let snapshot = try await db.collection("groupUsers").document(groupId ?? "").collection("participants").document(receiverUserId ?? "").collection("posts").order(by: "timeStamp", descending: true).getDocuments()
        
        let dtoDocuments = try snapshot.documents.map { document -> RollingPaperPostData in
            let data = try document.data(as: RollingPaperPostData.self)
            return RollingPaperPostData(from: data.from,
                                        postTheme: data.postTheme,
                                        message: data.message,
                                        image: data.image,
                                        isPublic: data.isPublic,
                                        timeStamp: data.timeStamp)
        }
        
        var documents: [RollingPaperPostData] = []
        for dtoDocument in dtoDocuments {
            documents.append(dtoDocument)
        }
        return documents
    }
}
