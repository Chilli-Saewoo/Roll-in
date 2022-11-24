//
//  GroupBaseViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/23.
//

import UIKit

final class GroupBaseViewController: UIViewController {
    
    lazy var confirmButton = UIButton()
    lazy var viewTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GroupBaseViewController {
    
    func setLayout() {
        //Override Layout
    }
    
    func setConfirmButton(buttonTitle: String) {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        confirmButton.setTitle(buttonTitle, for: .normal)
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.backgroundColor = .systemBlack
    }
    
    func setViewTitle(title: String) {
        view.addSubview(viewTitle)
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        viewTitle.text = title
        viewTitle.font = .systemFont(ofSize: 24, weight: .bold)
        viewTitle.textColor = .systemBlack
        
    }
}
