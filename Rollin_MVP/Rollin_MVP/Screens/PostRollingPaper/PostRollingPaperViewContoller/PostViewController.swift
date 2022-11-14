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
    var myGroupNickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setWriteButtonLayout()
        configurePostViewController()
        setupPostViewControllerLayout()
        fetchAllPosts()
        setNavigationBarBackButton()
    }
    
    
    private func setupDataSource() {
        for post in posts {
            var image = UIImage()
            FirebaseStorageManager.downloadImage(urlString: post.image) { uiImage in
                guard let uiImage = uiImage else { return }
                image = uiImage
                let color = UIColor(hex: "#\(post.postTheme)")
                self.dataSource.append(PostRollingPaperModel(color: color, commentString: post.message, image: image.resizeImage(newWidth: 170) ?? UIImage(), timestamp: post.timeStamp, from: post.from, isPublic: post.isPublic))
                self.dataSource.sort(by: >)
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
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteRollingPaperViewController") as? WriteRollingPaperViewController ?? UIViewController()
        let vc = viewController as? WriteRollingPaperViewController
        guard let groupId = groupId else {return}
        guard let receiverUserId = receiverUserId else {return}
        guard let myGroupNickname = myGroupNickname else {return}
        vc?.groupId = groupId
        vc?.receiverUserId = receiverUserId
        vc?.writerNickname = myGroupNickname
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
            writeButton.setImage(writeButtonImage, for: .normal)
            writeButton.tintColor = .systemBlack
            writeButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                writeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 122),
                writeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
                writeButton.widthAnchor.constraint(equalToConstant: 25),
                writeButton.heightAnchor.constraint(equalToConstant: 25),
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
        collectionView.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor).isActive = true
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
        let imageHeight = (UIScreen.main.bounds.width - 10)/2
        let labelHeight = dataSource[indexPath.item].commentString.heightWithConstrainedWidth(width: UIScreen.main.bounds.width/2-50, font: UIFont.systemFont(ofSize: 17, weight: .medium))
        return imageHeight + labelHeight + 40
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostRollingPaperCollectionViewCell.id, for: indexPath) as? PostRollingPaperCollectionViewCell ?? PostRollingPaperCollectionViewCell()
        cell.myModel = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rollingPaperDetailViewController = DetailRollingPaperViewController()
        rollingPaperDetailViewController.view.backgroundColor = .white
        rollingPaperDetailViewController.modalPresentationStyle = .pageSheet
        rollingPaperDetailViewController.myModel = dataSource[indexPath.item]
        
        if let halfModal = rollingPaperDetailViewController.sheetPresentationController {
            halfModal.preferredCornerRadius = 10
            halfModal.detents = [.medium()]
            halfModal.delegate = self
            halfModal.prefersGrabberVisible = true
        }
        
        present(rollingPaperDetailViewController, animated: true, completion: nil)
    }
}


private extension PostViewController {
    func fetchPosts() async throws -> [RollingPaperPostData] {
        let db = FirebaseFirestore.Firestore.firestore()
        let snapshot = try await db.collection("groupUsers").document(groupId ?? "").collection("participants").document(receiverUserId ?? "").collection("posts").order(by: "timeStamp", descending: true).getDocuments()
        let uid = UserDefaults.standard.string(forKey: "uid")
        let myGroupNickname = try await db.collection("groupUsers").document(groupId ?? "").collection("participants").document(uid ?? "").getDocument().data()
        guard let myGroupNickname = myGroupNickname else { return [RollingPaperPostData(from: "", postTheme: "", message: "", image: "", isPublic: false, timeStamp: Date())]}
        self.myGroupNickname = String(describing: myGroupNickname["groupNickname"] ?? "")
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
        return documents.sorted(by: >)
    }
}

extension PostViewController {
    func setNavigationBarBackButton() {
        guard let groupNickname = groupNickname else { return }
        let backBarButtonItem = UIBarButtonItem(title: "\(groupNickname)님의 롤링페이퍼", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
