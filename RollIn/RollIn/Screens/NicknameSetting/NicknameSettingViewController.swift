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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNicknameMessageLabel()
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
            nicknameMessageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }
}

// MARK: - nick name 텍스트필드를 세팅합니다.
private extension NicknameSettingViewController {
    func configureNicknameTextField() {
        view.addSubview(nicknameTextField)
    }
}
