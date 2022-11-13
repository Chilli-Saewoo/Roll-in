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
    private var groups: [Group] = [] {
        didSet {
            print(groups)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainTitleLabel()
        setAddGroupCard()
        addGroupCard.delegate = self
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

extension MainViewController: AddGroupButtonBackgroundDelegate {
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
                                        for document in querySnapshot?.documents ?? [] {
                                            group.participants?.append((document.documentID, document.data()["groupNickname"] as? String ?? ""))
                                        }
                                        group.groupId = groupId
                                        self.groups.append(group)
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
}


