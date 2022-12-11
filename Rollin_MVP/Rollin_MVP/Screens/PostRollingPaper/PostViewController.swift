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

    private let contentWidth: CGFloat = (UIScreen.main.bounds.width - 34) / 2 - 7 * 2
    
    var collectionView: UICollectionView!
    private lazy var titleMessageLabel = UILabel()
    private lazy var writeButton = UIButton()
    private lazy var plusButton = UIButton()
    private lazy var resetIngroupNicknameLabel = UILabel()
    private lazy var resetIngroupNicknameButton = UIButton()
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
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.isHidden = false
        activityIndicator.color = .systemBlack
        return activityIndicator
    }()
    private var isEmptyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 아무도 답장을 하지 않았어요"
        label.textColor = .inactiveBgGray
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.layer.opacity = 0.0
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        configurePostViewController()
        setupPostViewControllerLayout()
        setNavigationBarBackButton()
        setIngroupNicknameLabel()
        setIngroupNicknameButton()
        view.addSubview(activityIndicator)
        setIsEmptyTextLabelLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.stopAnimating()
        setWriteButtonLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllPosts()
    }
    
    private func setIsEmptyTextLabelLayout() {
        view.addSubview(isEmptyTextLabel)
        isEmptyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isEmptyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isEmptyTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func fetchAllPosts() {
        Task {
            self.activityIndicator.startAnimating()
            self.posts = try await fetchPosts()
            collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.fetchImagesByPostId()
            if (posts?.isEmpty ?? true) && receiverUserId == UserDefaults.standard.string(forKey: "uid") {
                isEmptyTextLabel.layer.opacity = 1.0
            } else {
                isEmptyTextLabel.layer.opacity = 0.0
            }
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
                                           id: document.documentID, // TODO: - DB에 POST 아이디가 필요
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
    
    private func setResetIngroupNicknameButton() {
        resetIngroupNicknameButton.addTarget(self, action: #selector(resetIngroupNicknameButtonPressed), for: .touchUpInside)
    }
    
    @objc private func resetIngroupNicknameButtonPressed() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetIngroupNicknameViewController") as? ResetIngroupNicknameViewController ?? UIViewController()
        let vc = viewController as? ResetIngroupNicknameViewController
        guard let groupId = groupId else { return }
        guard let receiverNickname = receiverNickname else { return }
        vc?.groupId = groupId
        vc?.receiverNickname = receiverNickname
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension PostViewController {
    private func configurePostViewController() {
        let collectionViewLayout = PostRollingPaperLayout()
        if receiverUserId == UserDefaults.standard.string(forKey: "uid") {
            collectionViewLayout.isWriteButtonHidden = true
        }
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
            collectionView.addSubview(writeButton)
            writeButton.setTitle("+ 추가하기", for: .normal)
            writeButton.setTitleColor(.black, for: .normal)
            writeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            writeButton.backgroundColor = .white
            writeButton.layer.borderWidth = 1
            writeButton.layer.cornerRadius = 4
            writeButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            writeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                writeButton.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 7),
                writeButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 7),
                writeButton.widthAnchor.constraint(equalToConstant: contentWidth),
                writeButton.heightAnchor.constraint(equalToConstant: contentWidth),
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
        titleMessageLabel.text = groupNickname
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
        if post.isPublic {
            cell.blurView.layer.opacity = 0.0
            cell.blurLockImage.layer.opacity = 0.0
        } else if receiverUserId == UserDefaults.standard.string(forKey: "uid") || post.from == writerNickname {
            cell.blurView.layer.opacity = 0.0
            cell.blurLockImage.layer.opacity = 0.0
        } else {
            cell.blurView.layer.opacity = 1.0
            cell.blurLockImage.layer.opacity = 1.0
        }
        let textColor = getTextColor(textColorString: post.postTheme)
        if let image = images[post.id] {
            cell.messageLabel.text = post.message
            cell.messageLabel.textColor = textColor
            cell.fromLabel.text = "From. \(post.from)"
            cell.fromLabel.textColor = textColor
            cell.containerView.backgroundColor = hexStringToUIColor(hex: post.postTheme)
            cell.imageView.image = image
            cell.isUserInteractionEnabled = true
        } else {
            cell.messageLabel.text = ""
            cell.fromLabel.text = ""
            cell.containerView.backgroundColor = hexStringToUIColor(hex: "F1F1F1")
            cell.imageView.image = UIImage(named: "skeleton")
            cell.isUserInteractionEnabled = false
        }
        if post.isPublic {
            cell.setupPublicPostViewLayout()
        } else if !post.isPublic {
            cell.setupPrivatePostViewLayout()
        }
        cell.setPrivacyViewLayout()
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
            halfModal.prefersGrabberVisible = false
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
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

private extension PostViewController {
    func setIngroupNicknameButton() {
        if receiverUserId == UserDefaults.standard.string(forKey: "uid") {
            view.addSubview(resetIngroupNicknameButton)
            resetIngroupNicknameButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                resetIngroupNicknameButton.centerYAnchor.constraint(equalTo: titleMessageLabel.centerYAnchor),
                resetIngroupNicknameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                resetIngroupNicknameButton.widthAnchor.constraint(equalToConstant: 75),
                resetIngroupNicknameButton.heightAnchor.constraint(equalToConstant: 24),
            ])
            resetIngroupNicknameButton.backgroundColor = .systemBlack
            resetIngroupNicknameButton.layer.cornerRadius = 4.0
            setResetIngroupNicknameButton()
        }
    }
    
    func setIngroupNicknameLabel() {
        if receiverUserId == UserDefaults.standard.string(forKey: "uid") {
            resetIngroupNicknameButton.addSubview(resetIngroupNicknameLabel)
            resetIngroupNicknameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                resetIngroupNicknameLabel.centerXAnchor.constraint(equalTo: resetIngroupNicknameButton.centerXAnchor),
                resetIngroupNicknameLabel.centerYAnchor.constraint(equalTo: resetIngroupNicknameButton.centerYAnchor),
                resetIngroupNicknameLabel.widthAnchor.constraint(equalTo: resetIngroupNicknameButton.widthAnchor),
                resetIngroupNicknameLabel.heightAnchor.constraint(equalTo: resetIngroupNicknameButton.heightAnchor),
            ])
            resetIngroupNicknameLabel.isUserInteractionEnabled = false
            let imageAttachment = NSTextAttachment()
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
            imageAttachment.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis", withConfiguration: imageConfig)?.withTintColor(.white)
            let buttonTitle = NSMutableAttributedString(attachment: imageAttachment)
            buttonTitle.append(NSMutableAttributedString(string: " 닉네임 수정"))
            resetIngroupNicknameLabel.attributedText = buttonTitle
            resetIngroupNicknameLabel.font = .systemFont(ofSize: 10, weight: .medium)
            resetIngroupNicknameLabel.textColor = .white
            resetIngroupNicknameLabel.textAlignment = .center
        }
    }
}
