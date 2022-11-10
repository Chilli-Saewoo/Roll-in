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
    private lazy var groupCodeView = GroupCodeView(code: creatingGroupInfo?.code ?? "설정되지 않음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTitleMessageLayout()
        setGroupCodeView()
        groupCodeView.delegate = self
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
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        titleMessageLabel.text = "아래 코드를 공유해서\n롤링페이퍼를 시작해보세요"
        titleMessageLabel.numberOfLines = 0
        
    }
    
    func setGroupCodeView() {
        view.addSubview(groupCodeView)
        groupCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupCodeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupCodeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            groupCodeView.heightAnchor.constraint(equalToConstant: 80),
            groupCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            groupCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])

    }
}
