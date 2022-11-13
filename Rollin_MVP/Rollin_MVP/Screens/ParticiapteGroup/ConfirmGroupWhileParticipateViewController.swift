//
//  ConfirmGroupWhileParticipateViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/13.
//

import UIKit

class ConfirmGroupWhileParticipateViewController: UIViewController {
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
    }
    
    private func setCompleteButtonAction() {
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed(_ sender: UIButton) {
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupCodeSharing") as? GroupCodeSharingViewController ?? UIViewController()
//        (secondViewController as? GroupCodeSharingViewController)?.creatingGroupInfo = creatingGroupInfo
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        
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
        completeButton.setTitle("완료", for: .normal)
        completeButton.layer.cornerRadius = 4.0
        completeButton.backgroundColor = .systemBlack
    }
}

