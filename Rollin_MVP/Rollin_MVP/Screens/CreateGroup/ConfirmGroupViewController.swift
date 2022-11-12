//
//  ConfirmGroupViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit
import FirebaseFirestore

let dummyUUID = "6d5601db-24b7-44e0-af2b-fba491471ec5"
let dummyNickname = "Sherry"


final class ConfirmGroupViewController: UIViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private lazy var titleMessageLabel = UILabel()
    private lazy var confirmGroupCard = GroupWithThemeView(info: creatingGroupInfo ?? CreatingGroupInfo())
    private let completeButton = UIButton()
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setConfirmGroupCard()
        setCompleteButton()
        setCompleteButtonAction()
    }
    
    private func setCompleteButtonAction() {
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed(_ sender: UIButton) {
        batchUpdateGroup()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupCodeSharing") as? GroupCodeSharingViewController ?? UIViewController()
        (secondViewController as? GroupCodeSharingViewController)?.creatingGroupInfo = creatingGroupInfo
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    private func batchUpdateGroup() {
        let groupId = UUID().uuidString
        let batch = db.batch()
        let groupsRef = db.collection("groups").document(groupId)
        let userGroupsRef = db.collection("userGroups").document(dummyUUID)
        let groupUsersRef = db.collection("groupUsers").document(groupId).collection("participants").document(dummyUUID)
        // 나중에는 현재 아이디로 수정 필요
        if let info = creatingGroupInfo {
            batch.setData(["code": info.code ?? "code Error",
                           "groupName": info.groupName ?? "group name Error",
                           "groupTheme": info.backgroundColor ?? "group Theme Error",
                           "groupIcon": info.icon ?? "icon Error",
                           "timestamp": info.createdTime ?? Date()],
                          forDocument: groupsRef)
            batch.setData(["division": FieldValue.arrayUnion([groupId])],
                                         forDocument: userGroupsRef, merge: true)
            batch.setData([:], forDocument: db.collection("groupUsers").document(groupId))
            batch.setData(["groupNickname": dummyNickname], forDocument: groupUsersRef)
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                }
            }
        }
    }
}

private extension ConfirmGroupViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.text = "해당 그룹이 맞으신가요?"
        titleMessageLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleMessageLabel.textColor = .systemBlack
        
    }
    
    func setConfirmGroupCard() {
        view.addSubview(confirmGroupCard)
        confirmGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmGroupCard.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 25),
            confirmGroupCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            confirmGroupCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            confirmGroupCard.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    func setCompleteButton() {
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        completeButton.setTitle("완료", for: .normal)
        completeButton.layer.cornerRadius = 4.0
        completeButton.backgroundColor = .systemBlack
    }
}
