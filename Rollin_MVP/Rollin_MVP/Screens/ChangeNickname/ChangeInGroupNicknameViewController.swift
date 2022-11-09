//
//  ChangeInGroupNicknameViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/09.
//

import UIKit

final class ChangeInGroupNicknameViewController: UIViewController {
    private lazy var newNicknameTextfield = UITextField()
    private lazy var titleLabel = UILabel()
    private lazy var completeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLayout()
        setNewNicknameTextfieldLayout()
        setCompleteButtonLayout()
    }
}

private extension ChangeInGroupNicknameViewController {
    func setTitleLayout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        titleLabel.text = "닉네임 수정"
    }
    
    func setNewNicknameTextfieldLayout() {
        view.addSubview(newNicknameTextfield)
        newNicknameTextfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newNicknameTextfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            newNicknameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            newNicknameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])

    }
    
    func setCompleteButtonLayout() {
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            completeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        completeButton.backgroundColor = .lightGray
        completeButton.setTitle("변경하기", for: .normal)
        completeButton.setTitleColor(.black, for: .normal)
    }
}
