//
//  NicknameSettingViewController.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/21.
//

import UIKit
import Firebase

final class NicknameSettingViewController: UIViewController {
    private let titleLabel = UILabel()
    private let nicknameTextField = UITextField()
    private let textFieldBottomLine = UIView()
    private let confirmButton = UIButton()
    private let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageLabel()
        configureNicknameTextField()
        nicknameTextField.delegate = self
        configureConfirmButton()
        nicknameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initalizeUserInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func initalizeUserInfo() {
        UserDefaults.nickname = nil
        UserDefaults.userId = nil
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
//        uploadNewUserData()
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeEnrollVC") ?? UIViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
    private func uploadNewUserData() {
        guard let userId = UserDefaults.userId else { return }
        guard let nickname = UserDefaults.nickname else { return }
        self.ref.child("users").child(userId).setValue(["nickname": nickname])
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
        view.addSubview(titleLabel)
        setMessageLabelLayout()
        titleLabel.text = "이름을 설정해주세요"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setMessageLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 175),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
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
            nicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
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
