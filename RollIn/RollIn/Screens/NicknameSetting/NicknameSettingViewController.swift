//
//  NicknameSettingViewController.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/21.
//

import UIKit

final class NicknameSettingViewController: UIViewController {
    private let messageLabel = UILabel()
    private let nicknameTextField = UITextField()
    private let textFieldBottomLine = UIView()
    private let confirmButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageLabel()
        configureNicknameTextField()
        nicknameTextField.delegate = self
        configureConfirmButton()
        nicknameTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else {
            confirmButton.backgroundColor = .gray
            confirmButton.isEnabled = false
            return
        }
        let count = text.count
        confirmButton.isEnabled = count > 0 ? true : false
        confirmButton.backgroundColor = count > 0 ? .orange : .gray
    }
    
    @objc func confirmButtonPressed(_ sender: UIButton) {
        UserDefaults.nickname = nicknameTextField.text
        UserDefaults.userId = UUID().uuidString
        // TODO: firebase에 User 모델을 저장하는 로직이 필요합니다.
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeEnrollVC") ?? UIViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
}

extension NicknameSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let maxLength = 10
        if text.count >= maxLength {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if isBackSpace == -92 {
                    return true
                }
            }
            return false
        }
        return true
    }
}

// MARK: - nick name message를 세팅합니다.
private extension NicknameSettingViewController {
    func configureMessageLabel() {
        view.addSubview(messageLabel)
        setMessageLabelLayout()
        messageLabel.text = "이름을 설정해주세요"
        messageLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setMessageLabelLayout() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 175),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}

// MARK: - nick name 텍스트필드를 세팅합니다.
private extension NicknameSettingViewController {
    func configureNicknameTextField() {
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldBottomLine)
        setNicknameTextFieldLayout()
        setTextFieldBottomLineLayout()
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textFieldBottomLine.backgroundColor = .black
        
    }
    
    func setNicknameTextFieldLayout() {
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setTextFieldBottomLineLayout() {
        textFieldBottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldBottomLine.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 5),
            textFieldBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textFieldBottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - nick name confirm Button을 세팅합니다.
private extension NicknameSettingViewController {
    func configureConfirmButton() {
        view.addSubview(confirmButton)
        setConfirmButtonLayout()
        confirmButton.layer.cornerRadius = 8.0
        confirmButton.setTitle("다음", for: .normal)
        confirmButton.backgroundColor = .gray
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
    }
    
    func setConfirmButtonLayout() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
