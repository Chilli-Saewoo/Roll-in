//
//  SetNicknameWhileCreatingGroupViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

final class SetNicknameWhileCreatingGroupViewController: UIViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private lazy var titleMessageLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var textFieldUnderLineView = UIView()
    private lazy var nextButton = UIButton()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1) .isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleMessageLayout()
        setNameTextFieldLayout()
        setNextButtonLayout()
        setNextButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeKeboardHeight()
        nameTextField.becomeFirstResponder()
    }
    
    private func setNextButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        guard let text = nameTextField.text else { return }
        creatingGroupInfo?.nickName = text
        creatingGroupInfo?.createdTime = Date()
        creatingGroupInfo?.code = 8.randomString()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetTheme") as? SetThemeViewController ?? UIViewController()
        (secondViewController as? SetThemeViewController)?.creatingGroupInfo = creatingGroupInfo
        self.navigationController?.pushViewController(secondViewController, animated: true)
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

private extension SetNicknameWhileCreatingGroupViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.text = "그룹 내 닉네임을 입력해주세요"
        titleMessageLabel.font = .systemFont(ofSize: 24, weight: .medium)
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
    
    func setNextButtonLayout() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        nextButton.backgroundColor = .gray
        nextButton.setTitle("다음", for: .normal)
    }
}
