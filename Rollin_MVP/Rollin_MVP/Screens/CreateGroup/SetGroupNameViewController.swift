//
//  CreateGroupViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/08.
//

import UIKit

final class SetGroupNameViewController: UIViewController {
    
    private lazy var titleMessage = UILabel()
    private lazy var nameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setNameTextFieldLayout()
    }
}

private extension SetGroupNameViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessage)
        titleMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        
    }
    
    func setNameTextFieldLayout() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleMessage.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])
    }
}
