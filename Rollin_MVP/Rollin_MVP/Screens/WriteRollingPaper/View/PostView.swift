//
//  PostView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

protocol WriteRollingPaperViewControllerDelegate: AnyObject {
    func activeConfirmButton()
    
    func inactiveConfirmButton()
}

final class PostView: UIView {
    
    var isPhotoAdded: Bool = false
    var isTextEdited: Bool = false
    
    weak var delegate: WriteRollingPaperViewControllerDelegate?
    
    let privateSwitch: UISwitch = {
        let privateSwitch = UISwitch()
        privateSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        privateSwitch.onTintColor = .systemBlack
        privateSwitch.setOn(true, animated: false)
        return privateSwitch
    }()
    
    private let privateSwitchTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹내 공개"
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/100"
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .bgRed
        textView.textColor = .textRed
        textView.tintColor = .textRed
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 12, bottom: 36, right: 12)
        textView.text = "롤링페이퍼를 입력하세요"
        textView.layer.cornerRadius = 4
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        return textView
    }()
    
    let emptyImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진 추가하기", for: .normal)
        button.setTitleColor(.systemBlack, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlack
        button.backgroundColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    let addedImageButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    let fromLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .textRed
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPostLayout()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPostLayout() {
        addSubview(textCountLabel)
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textCountLabel.topAnchor.constraint(equalTo: topAnchor),
            textCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textCountLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(privateSwitch)
        privateSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateSwitch.centerYAnchor.constraint(equalTo: textCountLabel.centerYAnchor),
            privateSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
        ])
        
        addSubview(privateSwitchTitleLabel)
        privateSwitchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateSwitchTitleLabel.centerYAnchor.constraint(equalTo: privateSwitch.centerYAnchor),
            privateSwitchTitleLabel.trailingAnchor.constraint(equalTo: privateSwitch.leadingAnchor, constant: 0),
            privateSwitchTitleLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textCountLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 164),
        ])
        
        addSubview(emptyImageButton)
        emptyImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyImageButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
            emptyImageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyImageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyImageButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyImageButton.heightAnchor.constraint(equalToConstant: 66)
        ])
        
        addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fromLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -8),
            fromLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12),
        ])
        
    }
    
    func setupAddedImageButtonLayout() {
        addSubview(addedImageButton)
        addedImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addedImageButton.topAnchor.constraint(equalTo: textView.bottomAnchor),
            addedImageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addedImageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addedImageButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addedImageButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func checkTextLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isLimit = text.count + newText.count <= limit
        return isLimit
    }
}


extension PostView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return self.checkTextLimit(existingText: textView.text,
                                  newText: text,
                                  limit: 100)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCountLabel.text = "\(textView.text.count)/100"
        if isTextEdited && isPhotoAdded {
            delegate?.activeConfirmButton()
        } else {
            delegate?.inactiveConfirmButton()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isTextEdited {
            textView.text = ""
            isTextEdited = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let textWithoutWhiteSpace = textView.text.trimmingCharacters(in: .whitespaces)
        if isTextEdited && textWithoutWhiteSpace == "" {
            textView.text = "롤링페이퍼를 입력하세요"
            textCountLabel.text = "0/100"
            isTextEdited = false
            delegate?.inactiveConfirmButton()
        }
    }
}
