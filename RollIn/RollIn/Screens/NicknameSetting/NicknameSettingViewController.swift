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
    private let nicknameTextDescriptionLabel = UILabel()
    private let confirmButton = UIButton()
    private let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageLabel()
        configureNicknameTextField()
        nicknameTextField.delegate = self
        configureNicknameTextDescriptionLabel()
        configureConfirmButton()
        nicknameTextField.becomeFirstResponder()
        self.view.backgroundColor = .CustomBackgroundColor
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeUserIfExist()
        initalizeUserInfo()
    }
    
    private func removeUserIfExist() {
        guard let userId = UserDefaults.userId else { return }
        self.ref.child("users").child(userId).removeValue()
    }
    
    private func initalizeUserInfo() {
        UserDefaults.nickname = nil
        UserDefaults.userId = nil
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard sender.text != nil else {
            confirmButton.backgroundColor = .hwOrangeInactive
            return
        }
        guard let nickname = nicknameTextField.text else { return }
        confirmButton.backgroundColor = nickname.trimmingCharacters(in: .whitespaces).count > 0 ? .hwOrange : .hwOrangeInactive
    }
    
    @objc func confirmButtonPressed(_ sender: UIButton) {
        guard let nickname = nicknameTextField.text else { return }
        if nickname.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        UserDefaults.nickname = nicknameTextField.text
        UserDefaults.userId = UUID().uuidString
        uploadNewUserData()
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeEnrollVC") ?? UIViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    private func uploadNewUserData() {
        guard let userId = UserDefaults.userId else { return }
        guard let nickname = UserDefaults.nickname else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateStr = dateFormatter.string(from: Date())
        self.ref.child("users").child(userId).setValue(["nickname": nickname,  "timestamp": dateStr])
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

// MARK: - Background Color??? ???????????????.
func backgroundColor() {
    
}

// MARK: - nick name message??? ???????????????.
private extension NicknameSettingViewController {
    func configureMessageLabel() {
        view.addSubview(titleLabel)
        setMessageLabelLayout()
        titleLabel.text = "???????????? ??????????????????"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
    }
    
    func setMessageLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 117),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}

// MARK: - nick name ?????????????????? ???????????????.
private extension NicknameSettingViewController {
    func configureNicknameTextField() {
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldBottomLine)
        setNicknameTextFieldLayout()
        setTextFieldBottomLineLayout()
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nicknameTextField.textColor = .white
        textFieldBottomLine.backgroundColor = .white
        nicknameTextField.setClearButton(with: UIImage(systemName: "xmark.circle.fill") ?? UIImage(), mode: .always)
        
    }
    
    func configureNicknameTextDescriptionLabel() {
        view.addSubview(nicknameTextDescriptionLabel)
        nicknameTextDescriptionLabelLayout()
        nicknameTextDescriptionLabel.text = "???????????? QR????????? ?????? ??????????????? \n?????? 10????????? ???????????????"
        nicknameTextDescriptionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        nicknameTextDescriptionLabel.numberOfLines = 2
        nicknameTextDescriptionLabel.addLabelSpacing(lineSpacing: 4)
        nicknameTextDescriptionLabel.textColor = .lightGray
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
    
    func nicknameTextDescriptionLabelLayout() {
        nicknameTextDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextDescriptionLabel.topAnchor.constraint(equalTo: textFieldBottomLine.bottomAnchor, constant: 10),
            nicknameTextDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
}

// MARK: - nick name confirm Button??? ???????????????.
private extension NicknameSettingViewController {
    func configureConfirmButton() {
        view.addSubview(confirmButton)
        setConfirmButtonLayout()
        confirmButton.setTitle("??????", for: .normal)
        confirmButton.backgroundColor = .hwOrangeInactive
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
    }
    
    func setConfirmButtonLayout() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        self.view.layoutIfNeeded()
        subscribeToShowKeyboardNotifications()
        nicknameTextField.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  (-keyboardHeight)).isActive = true
    }
    
    
    func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func buttonAction() {
        nicknameTextField.resignFirstResponder()
    }
}
