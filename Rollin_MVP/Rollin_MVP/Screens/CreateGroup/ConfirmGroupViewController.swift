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
    private lazy var confirmGroupCard = ConfirmGroupCardView(groupName: creatingGroupInfo?.groupName ?? "",date: creatingGroupInfo?.createdTime ?? Date())
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
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        titleMessageLabel.text = "해당 롤링페이퍼가 맞으신가요?"
        
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
            completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -65),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            completeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        completeButton.setTitle("완료", for: .normal)
        completeButton.layer.cornerRadius = 8.0
        completeButton.backgroundColor = .gray
    }
}
