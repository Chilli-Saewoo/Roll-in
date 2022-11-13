//
//  MainViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/08.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MainViewController: UIViewController {
    private let db = Firestore.firestore()
    private let mainTitleLabel = UILabel()
    private let addGroupCard = AddGroupButtonBackgroundView()
    private var groupsCollectionView: UICollectionView!
    private var groups: [Group] = [] {
        didSet {
            groupsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainTitleLabel()
        setAddGroupCard()
        setNavigationBarBackButton()
        addGroupCard.delegate = self
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

private extension MainViewController {
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let width: CGFloat = UIScreen.main.bounds.width - 40
        let height: CGFloat = 100
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        groupsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(groupsCollectionView)
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupsCollectionView.topAnchor.constraint(equalTo: addGroupCard.bottomAnchor, constant: 12),
            groupsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groupsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            groupsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        groupsCollectionView.backgroundColor =  .clear
    }
    
        func registerCollectionView() {
            groupsCollectionView.register(MainGroupCardViewCell.classForCoder(), forCellWithReuseIdentifier: "mainGroupCard")
        }
            
        func collectionViewDelegate() {
            groupsCollectionView.delegate = self
            groupsCollectionView.dataSource = self
        }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupsCollectionView.dequeueReusableCell(withReuseIdentifier: "mainGroupCard", for: indexPath) as? MainGroupCardViewCell ?? MainGroupCardViewCell()
        cell.setCardView(info: groups[indexPath.row])
        return cell
    }
}

extension MainViewController: AddGroupButtonBackgroundDelegate {
    func participateActionSelected() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchGroupWithCode") as? SearchGroupWithCodeViewController ?? UIViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func createActionSelected() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetGroupNameWhileCreatingGroup") as? SetGroupNameWhileCreatingGroupViewController ?? UIViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func showActionSheet(sheet: UIAlertController) {
        present(sheet, animated: true, completion: nil)
    }
    
    
}

private extension MainViewController {
    func fetchGroups() {
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            let docRef = db.collection("userGroups").document(uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let groupIds = document.data().map{
                        $0["division"] as? [String] ?? []
                    } ?? [String]()
                    self.groups.removeAll()
                    for groupId in groupIds {
                        let groupsRef = self.db.collection("groups").document(groupId)
                        groupsRef.getDocument(as: Group.self) { result in
                            switch result {
                                case .success(let group):
                                self.db.collection("groupUsers").document(groupId).collection("participants").getDocuments() { querySnapshot, error in
                                    if let err = error {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        group.participants = []
                                        for document in querySnapshot?.documents ?? [] {
                                            group.participants.append((document.documentID, document.data()["groupNickname"] as? String ?? ""))
                                            if document.documentID == UserDefaults.standard.string(forKey: "uid") ?? "" {
                                                group.groupNickname = document.data()["groupNickname"] as? String ?? ""
                                            }
                                        }
                                        group.groupId = groupId
                                        self.groups.append(group)
                                        self.groups.sort(by: <)
                                    }
                                }
                                case .failure(let error):
                                print("Error decoding group: \(error)")
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

private extension MainViewController {
    func setMainTitleLabel() {
        view.addSubview(mainTitleLabel)
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
        ])
        mainTitleLabel.font = .systemFont(ofSize: 26, weight: .medium)
        mainTitleLabel.text = "\(UserDefaults.standard.string(forKey: "nickname") ?? "")의 롤링페이퍼"
    }
    
    
    func setAddGroupCard() {
        view.addSubview(addGroupCard)
        addGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addGroupCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addGroupCard.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 40),
            addGroupCard.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "롤인 그룹", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}


