//
//  GroupBaseViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/23.
//

import UIKit

class GroupBaseViewController: UIViewController {
    
    lazy var confirmButton = UIButton()
    lazy var viewTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
}

extension GroupBaseViewController {
    
    func setLayout() {
        //Override Layout
        setConfirmButtonLayout()
        setViewTitleLayout()
    }
    
    func setConfirmButtonLayout() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    func setConfirmButton(buttonTitle: String) {
        confirmButton.isEnabled = true
        confirmButton.setTitle(buttonTitle, for: .normal)
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.backgroundColor = .systemBlack
    }
    
    func setDisabledConfirmButton(buttonTitle: String) {
        confirmButton.isEnabled = false
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.setTitle(buttonTitle, for: .disabled)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitleColor(.inactiveTextGray, for: .disabled)
        confirmButton.backgroundColor = .inactiveBgGray
    }
    
    func setViewTitleLayout() {
        view.addSubview(viewTitle)
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    func setViewTitle(title: String) {
        viewTitle.text = title
        viewTitle.font = .systemFont(ofSize: 24, weight: .bold)
        viewTitle.textColor = .systemBlack
    }
}
