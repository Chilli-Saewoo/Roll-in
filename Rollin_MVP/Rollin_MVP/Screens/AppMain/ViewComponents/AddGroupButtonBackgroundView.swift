//
//  AddGroupButtonBackgroundView.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/10.
//

import UIKit

protocol AddGroupButtonBackgroundDelegate: AnyObject {
    func showActionSheet(sheet: UIAlertController)
    func createActionSelected()
}

final class AddGroupButtonBackgroundView: UIView {
    private let addGroupTextLabel = UILabel()
    private let addGroupButton = UIButton()
    weak var delegate: AddGroupButtonBackgroundDelegate?
    private let addGroupSheet = UIAlertController(title: nil, message: "롤링페이퍼 유형을 선택해주세요", preferredStyle: .actionSheet)
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 4.0
        self.backgroundColor = .black
        setAddGroupTextLabel()
        setAddGroupButton()
        setAddGroupButtonAction()
        setActionSheet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setActionSheet() {
        let participateAction = UIAlertAction(title: "참가하기", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let createAction = UIAlertAction(title: "생성하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("생성하기")
            if let delegate = self.delegate {
                delegate.createActionSelected()
            }
        })
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        addGroupSheet.addAction(participateAction)
        addGroupSheet.addAction(createAction)
        addGroupSheet.addAction(cancleAction)
    }
    
    private func setAddGroupButtonAction() {
        addGroupButton.addTarget(self, action: #selector(addGroupButtonPressed), for: .touchUpInside)
    }
    
    @objc func addGroupButtonPressed(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.showActionSheet(sheet: addGroupSheet)
        }
    }
    
    private func setAddGroupTextLabel() {
        self.addSubview(addGroupTextLabel)
        addGroupTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addGroupTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        addGroupTextLabel.text = "+ 추가하기"
        addGroupTextLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        addGroupTextLabel.textColor = .white
        addGroupTextLabel.textAlignment = .center
    }
    
    private func setAddGroupButton() {
        self.addSubview(addGroupButton)
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addGroupButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addGroupButton.topAnchor.constraint(equalTo: self.topAnchor),
            addGroupButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}
