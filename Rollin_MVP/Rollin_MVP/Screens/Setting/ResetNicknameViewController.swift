//
//  ResetNicknameViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/28.
//

import UIKit
import FirebaseFirestore

class ResetNicknameViewController: UIViewController {
    private let db = Firestore.firestore()
    private lazy var titleMessageLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var textFieldUnderLineView = UIView()
    private lazy var completeButton = UIButton()
    private lazy var cancelButton = UIButton()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1) .isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setNameTextFieldLayout()
        setCompleteButtonLayout()
        setCompleteButtonAction()
        setCancelButton()
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeKeboardHeight()
        nameTextField.becomeFirstResponder()
    }
    
    private func setCompleteButtonAction() {
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    private func setNicknameUserDefault() {
        UserDefaults.standard.set(nameTextField.text, forKey: "nickname")
    }
    
    @objc func completeButtonPressed(_ sender: UIButton) {
        let uid = UserDefaults.standard.string(forKey: "uid") ?? ""
        db.collection("users").document(uid).setData([
            "usernickname": nameTextField.text ?? "",
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("닉네임 수정")
                self.setNicknameUserDefault()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func observeKeboardHeight() {
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
}

extension ResetNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                if range.location == 0 && range.length != 0 {
                    self.completeButton.isEnabled = false
                    self.completeButton.backgroundColor = .inactiveBgGray
                    self.completeButton.setTitleColor(.inactiveTextGray, for: .disabled)
                }
                return true
            }
        }
        guard textField.text!.count < 10 else { return false }
        if range.location == 0 && range.length != 0 {
            self.completeButton.isEnabled = false
            self.completeButton.backgroundColor = .inactiveBgGray
            self.completeButton.setTitleColor(.inactiveTextGray, for: .disabled)
        } else {
            self.completeButton.isEnabled = true
            self.completeButton.backgroundColor = .systemBlack
            self.completeButton.setTitleColor(.white, for: .normal)
        }
        return true
    }
}

private extension ResetNicknameViewController {
    func setCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -15),
            cancelButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        cancelButton.setImage(.init(systemName: "x.circle.fill"), for: .normal)
        cancelButton.tintColor = .systemGray
        cancelButton.addTarget(self, action: #selector(removeTextField), for: .touchUpInside)
    }
    
    @objc func removeTextField() {
        nameTextField.text = ""
        self.completeButton.isEnabled = false
        self.completeButton.backgroundColor = .inactiveBgGray
        self.completeButton.setTitleColor(.inactiveTextGray, for: .disabled)
    }
    
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.text = "닉네임 수정"
        titleMessageLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleMessageLabel.textColor = .systemBlack
    }
    
    func setNameTextFieldLayout() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        view.addSubview(textFieldUnderLineView)
        textFieldUnderLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldUnderLineView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            textFieldUnderLineView.heightAnchor.constraint(equalToConstant: 0.45),
            textFieldUnderLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            textFieldUnderLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])
        textFieldUnderLineView.backgroundColor = hexStringToUIColor(hex: "C6C6C8")
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
        completeButton.backgroundColor = .gray
        completeButton.setTitle("완료", for: .normal)
        completeButton.isEnabled = false
    }
}

