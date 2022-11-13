//
//  GroupCodeSharingViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

final class GroupCodeSharingViewController: UIViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private lazy var titleMessageLabel = UILabel()
    private let completeButton = UIButton()
    private lazy var groupCodeView = GroupCodeView(code: creatingGroupInfo?.code ?? "설정되지 않음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTitleMessageLayout()
        setGroupCodeView()
        setCompleteButton()
        groupCodeView.delegate = self
        completeButton.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
    }
    
    @objc func goToRoot(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension GroupCodeSharingViewController: GroupCodeViewDelegate {
    func showAlert(message: UIAlertController) {
        self.present(message, animated: true, completion: nil)
    }
}

private extension GroupCodeSharingViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.text = "아래 코드를 공유해서\n롤링페이퍼를 시작해보세요"
        titleMessageLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleMessageLabel.numberOfLines = 0
        
    }
    
    func setGroupCodeView() {
        view.addSubview(groupCodeView)
        groupCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupCodeView.topAnchor.constraint(equalTo: titleMessageLabel.bottomAnchor, constant: 166),
            groupCodeView.heightAnchor.constraint(equalToConstant: 60),
            groupCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setCompleteButton() {
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        completeButton.setTitle("시작하기", for: .normal)
        completeButton.layer.cornerRadius = 4.0
        completeButton.backgroundColor = .systemBlack
    }
}
