//
//  SearchGroupWithCodeViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/14.
//

import UIKit
import FirebaseFirestore

final class SearchGroupWithCodeViewController: UIViewController {
    private let db = Firestore.firestore()
    let participateGroupInfo = ParticipateGroupInfo()
    private lazy var titleMessageLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var textFieldUnderLineView = UIView()
    private lazy var nextButton = UIButton()
    private lazy var cancelButton = UIButton()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        setTitleMessageLayout()
        setNameTextFieldLayout()
        setNextButtonLayout()
        setNextButtonAction()
        setCancelButton()
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observeKeboardHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nextButton.isEnabled = true
    }
    
    private func setNextButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        self.nextButton.isEnabled = false
        guard let text = nameTextField.text else { return }
        searchGroupWithCode(code: text) { document in
            self.participateGroupInfo.code = text
            self.participateGroupInfo.groupId = document.documentID
            self.participateGroupInfo.groupName = document.data()["groupName"] as? String ?? ""
            self.participateGroupInfo.timeStamp = document.data()["timestamp"] as? Date ?? Date()
            self.participateGroupInfo.groupIcon = document.data()["groupIcon"] as? String ?? ""
            self.participateGroupInfo.groupTheme = document.data()["groupTheme"] as? String ?? ""
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmGroupWhileParticipate") as? ConfirmGroupWhileParticipateViewController ?? UIViewController()
            (secondViewController as? ConfirmGroupWhileParticipateViewController)?.participateGroupInfo = self.participateGroupInfo
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }

    }
    
    private func searchGroupWithCode(code: String, completion: @escaping (_: QueryDocumentSnapshot) -> Void) {
        db.collection("groups").whereField("code", isEqualTo: code)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // 기존에 있는지 검사하고 있으면 중복 alert
                    for document in querySnapshot!.documents {
                        print("run completion")
                        completion(document)
                    }
                    if querySnapshot!.documents.count == 0 {
                        self.nextButton.isEnabled = true
                        let dialogMessage = UIAlertController(title: "존재하지 않는 코드입니다", message: "다른 코드로 검색해보세요\n코드는 8자리입니다", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
                        print("alert")
                    }
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

extension SearchGroupWithCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                if (range.location == 0 && range.length != 0) {
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor = .inactiveBgGray
                    self.nextButton.setTitleColor(.inactiveTextGray, for: .disabled)
                }
                return true
            }
        }
        guard textField.text!.count < 8 else { return false }
        if (range.location == 0 && range.length != 0) {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .inactiveBgGray
            self.nextButton.setTitleColor(.inactiveTextGray, for: .disabled)
        } else {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = .systemBlack
            self.nextButton.setTitleColor(.white, for: .normal)
        }
        return true
    }
}

private extension SearchGroupWithCodeViewController {
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
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = .inactiveBgGray
        self.nextButton.setTitleColor(.inactiveTextGray, for: .disabled)
    }
    
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.text = "그룹 코드를 입력해주세요"
        titleMessageLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleMessageLabel.textColor = .systemBlack
        
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
            nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        nextButton.backgroundColor = .inactiveBgGray
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.inactiveTextGray, for: .disabled)
        nextButton.isEnabled = false
    }
}
