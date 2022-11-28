//
//  GroupCodeSharingViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

final class GroupCodeSharingViewController: GroupBaseViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private let completeButton = UIButton()
    private lazy var groupCodeView = GroupCodeView(code: creatingGroupInfo?.code ?? "설정되지 않음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewTitle(title: "아래 코드를 공유해서\n롤링페이퍼를 시작해보세요")
        viewTitle.numberOfLines = 0
        setConfirmButton(buttonTitle: "시작하기")
        setGroupCodeView()
        groupCodeView.delegate = self
        confirmButton.addTarget(self, action: #selector(goToRoot), for: .touchUpInside)
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
    
    func setGroupCodeView() {
        view.addSubview(groupCodeView)
        groupCodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupCodeView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 166),
            groupCodeView.heightAnchor.constraint(equalToConstant: 60),
            groupCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
