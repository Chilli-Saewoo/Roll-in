//
//  GroupCodeView.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

protocol GroupCodeViewDelegate: AnyObject {
    func showAlert(message: UIAlertController)
}

final class GroupCodeView: UIView {
    private let copyButtonLabel = UILabel()
    private let copyButtonBackground = UIButton()
    private let groupCodeLabel = UILabel()
    private let code: String?
    weak var delegate: GroupCodeViewDelegate?
    
    init(code: String) {
        self.code = code
        super.init(frame: .zero)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        setCopyButtonBackground()
        setCopyButtonLabel()
        setCopyButtonAction()
        setGroupCodeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCopyButtonAction() {
        copyButtonBackground.addTarget(self, action: #selector(copyButtonPressed), for: .touchUpInside)
    }
    
    @objc func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = self.code
        let dialogMessage = UIAlertController(title: "코드가 복사되었습니다.", message: "코드를 공유해서 친구들과 롤링페이퍼를 시작해보세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        if let delegate = delegate {
            delegate.showAlert(message: dialogMessage)
        }
    }
    
}

private extension GroupCodeView {
    func setCopyButtonBackground() {
        self.addSubview(copyButtonBackground)
        copyButtonBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyButtonBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            copyButtonBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            copyButtonBackground.widthAnchor.constraint(equalToConstant: 70),
            copyButtonBackground.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setCopyButtonLabel() {
        self.addSubview(copyButtonLabel)
        copyButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyButtonLabel.centerXAnchor.constraint(equalTo: copyButtonBackground.centerXAnchor),
            copyButtonLabel.centerYAnchor.constraint(equalTo: copyButtonBackground.centerYAnchor),
            copyButtonLabel.widthAnchor.constraint(equalTo: copyButtonBackground.widthAnchor),
            copyButtonLabel.heightAnchor.constraint(equalTo: copyButtonBackground.heightAnchor),
        ])
        copyButtonLabel.isUserInteractionEnabled = false
        copyButtonLabel.text = "복사하기"
        copyButtonLabel.textAlignment = .left
    }
    
    func setGroupCodeLabel() {
        self.addSubview(groupCodeLabel)
        groupCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupCodeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            groupCodeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
        ])
        groupCodeLabel.text = code ?? "코드 생성에 실패했습니다."
    }
}

