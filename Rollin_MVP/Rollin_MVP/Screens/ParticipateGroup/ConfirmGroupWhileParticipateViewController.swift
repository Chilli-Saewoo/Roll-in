//
//  ConfirmGroupWhileParticipateViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/14.
//

import UIKit
import FirebaseFirestore

class ConfirmGroupWhileParticipateViewController: UIViewController {
    private let db = Firestore.firestore()
    var participateGroupInfo: ParticipateGroupInfo?
    private lazy var titleMessageLabel = UILabel()
    private lazy var confirmGroupCard = ParticipateGroupConfirmCardView(info: participateGroupInfo ?? ParticipateGroupInfo())
    private let completeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setConfirmGroupCard()
        setCompleteButton()
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
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetNicknameWhileParticipate") as? SetNicknameWhileParticipateViewController ?? UIViewController()
        (secondViewController as? SetNicknameWhileParticipateViewController)?.participateGroupInfo = participateGroupInfo
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
}

private extension ConfirmGroupWhileParticipateViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.text = "해당 그룹이 맞으신가요?"
        titleMessageLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleMessageLabel.textColor = .systemBlack
        
    }
    
    func setConfirmGroupCard() {
        view.addSubview(confirmGroupCard)
        confirmGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmGroupCard.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 12),
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
        completeButton.setTitle("입장하기", for: .normal)
        completeButton.layer.cornerRadius = 4.0
        completeButton.backgroundColor = .systemBlack
    }
    
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "그룹 확인", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
