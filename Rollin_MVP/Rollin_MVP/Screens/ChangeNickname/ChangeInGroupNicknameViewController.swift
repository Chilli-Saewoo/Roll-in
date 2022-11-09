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
    private lazy var textfieldUnderlineView = UIView()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        observeKeboardHeight()
        newNicknameTextfield.becomeFirstResponder()
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

private extension ChangeInGroupNicknameViewController {
    func setLayout() {
        setTitleLayout()
        setNewNicknameTextfieldLayout()
        setCompleteButtonLayout()
    }
    
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

        view.addSubview(textfieldUnderlineView)
        textfieldUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfieldUnderlineView.topAnchor.constraint(equalTo: newNicknameTextfield.bottomAnchor, constant: 2),
            textfieldUnderlineView.heightAnchor.constraint(equalToConstant: 1),
            textfieldUnderlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            textfieldUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])
        textfieldUnderlineView.backgroundColor = .black
        
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
