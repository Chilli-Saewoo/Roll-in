//
//  ConfirmGroupWhileParticipateViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/14.
//

import UIKit
import FirebaseFirestore

class ConfirmGroupWhileParticipateViewController: GroupBaseViewController {
    private let db = Firestore.firestore()
    var participateGroupInfo: ParticipateGroupInfo?
    private lazy var confirmGroupCard = ParticipateGroupConfirmCardView(info: participateGroupInfo ?? ParticipateGroupInfo())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmButton(buttonTitle: "추가하기")
        setViewTitle(title: "해당 그룹이 맞으신가요?")
        setConfirmGroupCard()
        setCompleteButtonAction()
        setNavigationBarBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchParticipantsCount()
    }
    
    private func fetchParticipantsCount() {
        db.collection("groupUsers").document(participateGroupInfo?.groupId ?? "").collection("participants").getDocuments() { querySnapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                var participants = 0
                for _ in querySnapshot?.documents ?? [] {
                    participants += 1
                }
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(systemName: "person.fill")?.withTintColor(.systemBlack)
                imageAttachment.setImageHeight(height: 10)
                let fullString = NSMutableAttributedString(attachment: imageAttachment)
                fullString.append(NSMutableAttributedString(string: " \(participants)명 참여중"))
                self.confirmGroupCard.participateCountLabel.attributedText = fullString
            }
        }
    }
    
    private func setCompleteButtonAction() {
        confirmButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetNicknameWhileParticipate") as? SetNicknameWhileParticipateViewController ?? UIViewController()
        (secondViewController as? SetNicknameWhileParticipateViewController)?.participateGroupInfo = participateGroupInfo
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

private extension ConfirmGroupWhileParticipateViewController {

    func setConfirmGroupCard() {
        view.addSubview(confirmGroupCard)
        confirmGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmGroupCard.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 12),
            confirmGroupCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            confirmGroupCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            confirmGroupCard.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "그룹 확인", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
