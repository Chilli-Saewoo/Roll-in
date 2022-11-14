//
//  ReadRollingViewController.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift

class PostViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: [PostRollingPaperModel] = []
    var rollingPaperInfo: RollingPaperInfo?
    var writerNickname: String = "Nick"
    var groupId: String = "fa8cce5a-1522-473e-9eb4-08aae407b015"
    var receiverUserId: String = "rmEM5tNdBP7bi1v8Jgi4"
    var posts: [RollingPaperPostData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePostViewController()
        setupPostViewControllerLayout()
        fetchAllPosts()
    }
    
    private func setupDataSource() {
        for post in posts {
            var image = UIImage()
            FirebaseStorageManager.downloadImage(urlString: post.image) { uiImage in
                guard let uiImage = uiImage else { return }
                image = uiImage
                let color = UIColor(hex: "#\(post.postTheme)")
                self.dataSource.append(PostRollingPaperModel(color: color, commentString: post.message, image: image, contentHeightSize: CGFloat(arc4random_uniform(500))))
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
    
    private func setupPostViewControllerLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension PostViewController: PostRollingPaperLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
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


private extension PostViewController {
    func fetchPosts() async throws -> [RollingPaperPostData] {
        let db = FirebaseFirestore.Firestore.firestore()
        let snapshot = try await db.collection("groupUsers").document(groupId).collection("participants").document(receiverUserId).collection("posts").order(by: "timeStamp", descending: true).getDocuments()
        
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
