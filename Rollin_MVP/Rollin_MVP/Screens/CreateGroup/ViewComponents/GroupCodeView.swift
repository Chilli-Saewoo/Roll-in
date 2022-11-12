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
    private let codeBackgroundView = UIView()
    private let copyButtonLabel = UILabel()
    private let copyButtonBackground = UIButton()
    private let groupCodeLabel = UILabel()
    private let code: String?
    weak var delegate: GroupCodeViewDelegate?
    
    init(code: String) {
        self.code = code
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setCopyButtonBackground()
        setCopyButtonLabel()
        setGroupCodeLabel()
        setCopyButtonAction()
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
            copyButtonBackground.topAnchor.constraint(equalTo: self.topAnchor),
            copyButtonBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            copyButtonBackground.widthAnchor.constraint(equalTo: self.heightAnchor),
            copyButtonBackground.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
        copyButtonBackground.backgroundColor = .systemBlack
        copyButtonBackground.layer.cornerRadius = 4.0
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
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "square.on.square")?.withTintColor(.white)
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSMutableAttributedString(string: " 복사"))
        copyButtonLabel.attributedText = fullString
        copyButtonLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        copyButtonLabel.textColor = .white
        copyButtonLabel.textAlignment = .center
    }
    
    func setGroupCodeLabel() {
        self.addSubview(codeBackgroundView)
        codeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            codeBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            codeBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            codeBackgroundView.trailingAnchor.constraint(equalTo: copyButtonBackground.leadingAnchor, constant: -12)
        ])
        codeBackgroundView.backgroundColor = hexStringToUIColor(hex: "E9E9E9")
        codeBackgroundView.layer.cornerRadius = 4.0
        
        
        self.addSubview(groupCodeLabel)
        groupCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupCodeLabel.centerXAnchor.constraint(equalTo: codeBackgroundView.centerXAnchor),
            groupCodeLabel.centerYAnchor.constraint(equalTo: codeBackgroundView.centerYAnchor),
        ])
        groupCodeLabel.text = code ?? "코드 생성에 실패했습니다."
        groupCodeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}

