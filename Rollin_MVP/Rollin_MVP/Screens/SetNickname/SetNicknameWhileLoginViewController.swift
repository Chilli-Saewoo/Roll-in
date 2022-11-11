//
//  SetNicknameWhileLoginViewController.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit
import FirebaseFirestore

final class SetNicknameWhileLoginViewController: UIViewController {
    let creatingGroupInfo = CreatingGroupInfo()
    private lazy var titleMessageLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var textFieldUnderLineView = UIView()
    private lazy var nextButton = UIButton()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1).isActive = true
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
        let db = Firestore.firestore()
        let email = UserDefaults.standard.string(forKey: "userEmail")
        let uid = UserDefaults.standard.string(forKey: "uid")
        db.collection("users").document().setData([
            "email": email,
            "usernickname": nameTextField.text
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                
                print("닉네임 생성")
            }
        }
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") else {return}
                
        self.navigationController?.pushViewController(viewController, animated: true)
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

private extension SetNicknameWhileLoginViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        titleMessageLabel.text = "닉네임 입력"
        
    }
    
    func setNameTextFieldLayout() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])
        
        view.addSubview(textFieldUnderLineView)
        textFieldUnderLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldUnderLineView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 2),
            textFieldUnderLineView.heightAnchor.constraint(equalToConstant: 1),
            textFieldUnderLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            textFieldUnderLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])
        textFieldUnderLineView.backgroundColor = .black
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

