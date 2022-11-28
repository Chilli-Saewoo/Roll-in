//
//  ReadRollingViewController.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift

final class PostViewController: UIViewController, UISheetPresentationControllerDelegate {

    var collectionView: UICollectionView!
    private lazy var titleMessageLabel = UILabel()
    private lazy var writeButton = UIButton()
    private lazy var plusButton = UIButton()
    var groupId: String?
    var writerNickname: String?
    var receiverNickname: String?
    var receiverUserId: String?
    var posts: [PostData]?
    var images: [String : UIImage] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setWriteButtonLayout()
        configurePostViewController()
        setupPostViewControllerLayout()
        setNavigationBarBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllPosts()
    }
    
    func fetchAllPosts() {
        Task {
            self.posts = try await fetchPosts()
            collectionView.reloadData()
            self.fetchImagesByPostId()
        }
    }
    
    private func fetchPosts() async throws -> [PostData]? {
        let db = FirebaseFirestore.Firestore.firestore()
        let snapshot = try await db.collection("groupUsers").document(groupId ?? "").collection("participants").document(receiverUserId ?? "").collection("posts").order(by: "timeStamp", descending: true).getDocuments()
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        let groupNicknameData = try await db.collection("groupUsers").document(groupId ?? "").collection("participants").document(uid ?? "").getDocument().data()
        
        guard let groupNicknameData = groupNicknameData else { return nil }
        
        self.writerNickname = String(describing: groupNicknameData["groupNickname"] ?? "")
        
        let postDocuments = try snapshot.documents.map { document -> PostData? in
            let data = try document.data(as: PostCodableData.self)
            
            // TODO: - type은 이후에 Firebase에서 받아와서 들어와져야 합니다. 현재는 한 종류이기 때문에 상수로 들어가게 됩니다.
            // switch로 type을 받아온 후, type에 따라서 return 형식이 달라져야 합니다.
            guard let image = data.image, let message = data.message, let postTheme = data.postTheme  else { return nil }
            return PostWithImageAndMessage(type: .imageAndMessage,
                                           id: UUID().uuidString, // TODO: - DB에 POST 아이디가 필요
                                           timestamp: data.timeStamp,
                                           from: data.from, isPublic: data.isPublic,
                                           imageURL: image,
                                           message: message,
                                           postTheme: postTheme)
        }
        
        var newPosts: [PostData] = []
        for postDocument in postDocuments {
            if let postWithoutNil = postDocument {
                newPosts.append(postWithoutNil)
            }
        }
        return newPosts.sorted(by: >)
    }
    
    private func fetchImagesByPostId() {
        guard let posts = posts else { return }
        images = [:] // TODO: - ID가 새로 만들어지기 때문에 Dict을 비워주기 위한 임시 해결책
        for post in posts {
            switch post.type {
            case .imageAndMessage:
                let postWithType = post as? PostWithImageAndMessage
                guard let imageURL = postWithType?.imageURL else { return }
                FirebaseStorageManager.downloadImage(urlString: imageURL) { fetchedImage in
                    guard let fetchedImage = fetchedImage else { return }
                    if self.images[post.id] == nil {
                        self.images[post.id] = fetchedImage
                    }
                }
            case .image:
                print("preparing")
            case .message:
                print("preparing")
            }
        }
    }
    

    
    @objc private func didTapButton() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteRollingPaperViewController") as? WriteRollingPaperViewController ?? UIViewController()
        let vc = viewController as? WriteRollingPaperViewController
        guard let groupId = groupId else {return}
        guard let receiverUserId = receiverUserId else {return}
        guard let myGroupNickname = writerNickname else {return}
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
            let writeButtonImage = UIImage(systemName: "plus")
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
        guard let groupNickname = receiverNickname else { return }
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
}

extension PostViewController: PostRollingPaperLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let post = posts?[indexPath.item] as? PostWithImageAndMessage else { return 0 }
        let imageHeight = (UIScreen.main.bounds.width - 10)/2
        let labelHeight = post.message.heightWithConstrainedWidth(width: UIScreen.main.bounds.width / 2 - 50, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        return imageHeight + labelHeight + 35
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let post = posts?[indexPath.item] as? PostWithImageAndMessage else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostRollingPaperCollectionViewCell.id, for: indexPath) as? PostRollingPaperCollectionViewCell ?? PostRollingPaperCollectionViewCell()
        cell.receiverUserId = receiverUserId ?? ""
        if post.isPublic || receiverUserId == UserDefaults.standard.string(forKey: "uid") {
            cell.blurView.layer.opacity = 0.0
            cell.lockImage.layer.opacity = 0.0
        } else {
            cell.blurView.layer.opacity = 1.0
            cell.lockImage.layer.opacity = 1.0
        }
        let textColor = getTextColor(textColorString: post.postTheme)
        cell.messageLabel.text = post.message
        cell.messageLabel.textColor = textColor
        cell.fromLabel.text = "From. \(post.from)"
        cell.fromLabel.textColor = textColor
        cell.containerView.backgroundColor = hexStringToUIColor(hex: post.postTheme)
        if let image = images[post.id] {
            cell.imageView.image = image
        } else {
            cell.imageView.image = nil // TODO: - 대기 중 이미지가 들어가야 합니다.
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = posts?[indexPath.item] as? PostWithImageAndMessage else { return }
        let rollingPaperDetailViewController = DetailRollingPaperViewController()
        rollingPaperDetailViewController.post = post
        rollingPaperDetailViewController.image = images[post.id]
        rollingPaperDetailViewController.view.backgroundColor = .white
        rollingPaperDetailViewController.modalPresentationStyle = .pageSheet
        if let halfModal = rollingPaperDetailViewController.sheetPresentationController {
            halfModal.preferredCornerRadius = 10
            halfModal.detents = [.medium()]
            halfModal.delegate = self
            halfModal.prefersGrabberVisible = true
        }
        if post.isPublic || receiverUserId == UserDefaults.standard.string(forKey: "uid") {
            present(rollingPaperDetailViewController, animated: true, completion: nil)
        }
    }
}


private extension PostViewController {
    func getTextColor(textColorString: String) -> UIColor {
        switch textColorString  {
        case "FFFCDD":
            return hexStringToUIColor(hex: "9E6003")
        case "FEE0EA":
            return hexStringToUIColor(hex: "D61951")
        case "EBDDFF":
            return hexStringToUIColor(hex: "4D2980")
        case "DDEBFF":
            return hexStringToUIColor(hex: "4069CE")
        case "C8F6D5":
            return hexStringToUIColor(hex: "15843B")
        default:
            return hexStringToUIColor(hex: "9E6003")
        }
    }
}

extension PostViewController {
    func setNavigationBarBackButton() {
        guard let groupNickname = receiverNickname else { return }
        let backBarButtonItem = UIBarButtonItem(title: "\(groupNickname)님의 롤링페이퍼", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
