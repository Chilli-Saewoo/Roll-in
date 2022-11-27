//
//  ConfirmGroupViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit
import FirebaseFirestore

final class ConfirmGroupViewController: GroupBaseViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private lazy var confirmGroupCard = GroupWithThemeView(info: creatingGroupInfo ?? CreatingGroupInfo())
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewTitle(title: "해당 그룹이 맞으신가요?")
        setConfirmButton(buttonTitle: "완료")
        setConfirmGroupCard()
        setCompleteButtonAction()
    }
    
    private func setCompleteButtonAction() {
        confirmButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
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
        let userGroupsRef = db.collection("userGroups").document(UserDefaults.standard.string(forKey: "uid") ?? "")
        let groupUsersRef = db.collection("groupUsers").document(groupId).collection("participants").document(UserDefaults.standard.string(forKey: "uid") ?? "")
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
            batch.setData(["groupNickname": info.nickName ?? ""], forDocument: groupUsersRef)
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
    
    func setConfirmGroupCard() {
        view.addSubview(confirmGroupCard)
        confirmGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmGroupCard.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 186),
            confirmGroupCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            confirmGroupCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            confirmGroupCard.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
}
