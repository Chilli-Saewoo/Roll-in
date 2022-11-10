//
//  ConfirmGroupViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

final class ConfirmGroupViewController: UIViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private lazy var titleMessageLabel = UILabel()
    private lazy var confirmGroupCard = ConfirmGroupCardView(groupName: creatingGroupInfo?.groupName ?? "", date: creatingGroupInfo?.createdTime ?? Date())
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
        creatingGroupInfo?.code = 8.randomString()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupCodeSharing") as? GroupCodeSharingViewController ?? UIViewController()
        (secondViewController as? GroupCodeSharingViewController)?.creatingGroupInfo = creatingGroupInfo
        self.navigationController?.pushViewController(secondViewController, animated: true)
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
