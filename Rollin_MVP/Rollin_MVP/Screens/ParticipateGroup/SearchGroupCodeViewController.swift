//
//  SearchGroupCodeViewController.swift
//  Rollin_MVP
//
//  Created by Yeji on 2022/11/10.
//

import UIKit

class SearchGroupCodeViewController: UIViewController {
    let creatingGroupInfo = CreatingGroupInfo()  // group model 이거 들고오는게 맞나? 새로 들고와야하나?
    private lazy var titleMessageLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var textFieldUnderLineView = UIView()
    private lazy var nextButton = UIButton()
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardHeight * -1).isActive = true
        }
    }

    override func viewDidLoad() {  // 뷰의 로딩이 완료되었을 때 시스템에 의해 자동으로 호출. 화면이 처음 만들어질 때 한번만 실행
        super.viewDidLoad()
        setTitleMessageLayout()
        setNameTextFieldLayout()
        setNextButtonLayout()
        setNextButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {  // View가 나타날 것이라고 컨트롤러에 알리는 역할
        observeKeyboardHeight()
        nameTextField.becomeFirstResponder()
    }
    
    private func setNextButtonAction() {  // function:
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)  // 대상개체 및 작업메서드를 컨트롤과 연결
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {  // 이 함수는 NextButton이 눌러지면 실행된다. #35 참고
        // MARK: guard let(조건문이 참이 아니면 else 실행.) 여기서 적은 코드가 DB에 있어야 아래로 이동
        // MARK: 여기서 나는 코드가 DB에 있는지 확인하고 그 방을 들고와야한다
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmParticipatingGroup") as? ConfirmParticipatingGroupViewController ?? UIViewController()
//        (secondViewController as? ConfirmParticipatingGroupViewController)?.modelgroupinfo = modegroupinfo
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        // MARK: 모델을 어떻게 넣을 것인가..!
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
