//
//  PostTextTableViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/12/11.
//

import UIKit

final class PostTextCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .bgRed
        textView.textColor = .textRed
        textView.tintColor = .textRed
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 24, left: 24, bottom: 36, right: 24)
        textView.text = "전달할 말을 입력해주세요"
        textView.layer.cornerRadius = 8
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        return textView
    }()
    
    let fromLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .textRed
        return label
    }()
    
    var isTextEdited: Bool = false
    
    weak var postViewDelegate: PostViewDelegate?
    
    weak var writeRollingPaperViewDelegate: WriteRollingPaperViewDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDetailPostLayout()
        textView.delegate = self
    }
    
    private func setDetailPostLayout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setFromLabelLayout(isPictureTheme: false)
    }
    
    func setFromLabelLayout(isPictureTheme: Bool) {
        contentView.addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        if isPictureTheme {
            NSLayoutConstraint.activate([
                fromLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
                fromLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -52)
            ])
        } else {
            NSLayoutConstraint.activate([
                fromLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
                fromLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
            ])
        }
    }
    
    func setBackgroundColor(color: UIColor?) {
        textView.backgroundColor = color
    }
    
    private func checkTextLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isLimit = text.count + newText.count <= limit
        return isLimit
    }
}


extension PostTextCollectionViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return self.checkTextLimit(existingText: textView.text,
                                  newText: text,
                                  limit: 200)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if isTextEdited {
            writeRollingPaperViewDelegate?.activeConfirmButton()
        } else {
            writeRollingPaperViewDelegate?.inactiveConfirmButton()
        }
        postViewDelegate?.setTextCount(textCount: textView.text.count)
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
            textView.text = "전달할 말을 입력해주세요"
            postViewDelegate?.setTextCount(textCount: 0)
            isTextEdited = false
            writeRollingPaperViewDelegate?.inactiveConfirmButton()
        }
    }
}
