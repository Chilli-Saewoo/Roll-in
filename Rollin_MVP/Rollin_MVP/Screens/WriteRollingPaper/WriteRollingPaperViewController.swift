//
//  WriteRollingPaperViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class WriteRollingPaperViewController: UIViewController {
    
    private let postThemePicerkView = PostThemePickerView()
    private let postView = PostView()
    
    private let privateSwitch: UISwitch = {
        let privateSwitch = UISwitch()
        return privateSwitch
    }()
    
    private let privateSwitchTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹내 공개"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(postThemePicerkView)
        postThemePicerkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postThemePicerkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postThemePicerkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postThemePicerkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postThemePicerkView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(privateSwitch)
        privateSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateSwitch.topAnchor.constraint(equalTo: postThemePicerkView.bottomAnchor, constant: 8),
            privateSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        view.addSubview(privateSwitchTitleLabel)
        privateSwitchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateSwitchTitleLabel.centerYAnchor.constraint(equalTo: privateSwitch.centerYAnchor),
            privateSwitchTitleLabel.trailingAnchor.constraint(equalTo: privateSwitch.leadingAnchor, constant: -8)
        ])
        
        view.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: privateSwitch.bottomAnchor, constant: 8),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
        ])
    }
}

