//
//  NicknameSettingViewController.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/21.
//

import UIKit

final class NicknameSettingViewController: UIViewController {
    private let nicknameMessageLabel = UILabel()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldBottomLine = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNicknameMessageLabel()
        configureNicknameTextField()
    }
}

// MARK: - nick name message를 세팅합니다.
private extension NicknameSettingViewController {
    func configureNicknameMessageLabel() {
        view.addSubview(nicknameMessageLabel)
        setNicknameMessageLabelLayout()
        nicknameMessageLabel.text = "이름을 설정해주세요"
        nicknameMessageLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setNicknameMessageLabelLayout() {
        nicknameMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 175),
            nicknameMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}

// MARK: - nick name 텍스트필드를 세팅합니다.
private extension NicknameSettingViewController {
    func configureNicknameTextField() {
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameTextFieldBottomLine)
        setNicknameTextFieldLayout()
        setNicknameTextFieldBottomLineLayout()
        nicknameTextFieldBottomLine.backgroundColor = .black
        
    }
    
    func setNicknameTextFieldLayout() {
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameMessageLabel.bottomAnchor, constant: 30),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setNicknameTextFieldBottomLineLayout() {
        nicknameTextFieldBottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextFieldBottomLine.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 5),
            nicknameTextFieldBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextFieldBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextFieldBottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
