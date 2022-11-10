//
//  PostView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class PostView: UIView {
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("사진을 첨부해주세요", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .bgRed
        textView.textColor = .textRed
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 12, bottom: 36, right: 12)
        textView.layer.cornerRadius = 4
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 164),
        ])
        
        addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: textView.bottomAnchor),
            imageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-112)
        ])
    }
}
