//
//  SearchGroupCodeViewController.swift
//  Rollin_MVP
//
//  Created by Yeji on 2022/11/10.
//

import UIKit
import FirebaseFirestore

class SearchGroupCodeViewController: UIViewController {
    var db: Firestore!
    var codeText: String = ""
    private lazy var titleMessageLabel = UILabel()
    private lazy var textField = UITextField()
    private lazy var textFieldUnderLineView = UIView()
    private lazy var nextButton = UIButton()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1).isActive = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setTitleMessageLayout()
        setNameTextFieldLayout()
        setNextButtonLayout()
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNextButtonAction()
        observeKeyboardHeight()
        textField.becomeFirstResponder()
    }
    
    func codeCheck(code: String?) -> Bool {
        var codeCheckResult = false
        let groupDB = db.collection("groups")
        let query = groupDB.whereField("code", isEqualTo: codeText)
        
        query.getDocuments() { (qs, err) in
            if qs!.documents.isEmpty {
                print("데이터 중복 안 됨 그룹 참여 불가능")
                codeCheckResult = false
            } else {
                print("데이터 중복 됨 그룹 참여 가능")
                codeCheckResult = true
            }
        }
        return codeCheckResult
    }
    
    private func setNextButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    @objc func nextButtonPressed(_ sender: UIButton, code: String) {
        let codeCheckResult = codeCheck(code: textField.text)
        guard codeCheckResult == true else { return }
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmParticipatingGroupViewController") as? ConfirmParticipatingGroupViewController
//        secondViewController?.codeText = text ?? "" // 데이터 어떻게 보내지
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
    
    private func observeKeyboardHeight() {
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

extension SearchGroupCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 8 else { return false }
        
        if range.location < 7 {
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .lightGray
        } else {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = .black
        }
        
        return true
    }
}

private extension SearchGroupCodeViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        titleMessageLabel.text = "그룹 코드를 입력해주세요"
    }
    
    func setNameTextFieldLayout() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
        ])
        
        view.addSubview(textFieldUnderLineView)
        textFieldUnderLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldUnderLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2),
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
