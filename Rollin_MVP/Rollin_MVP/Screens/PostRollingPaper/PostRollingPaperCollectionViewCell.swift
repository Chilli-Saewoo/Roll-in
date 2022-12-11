//
//  PostRollingPaperCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

class PostRollingPaperCollectionViewCell: UICollectionViewCell {
    var receiverUserId: String = ""

    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }
    
    lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.clipsToBounds = true
        return visualEffectView
    }()
    
    lazy var lockImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "lock.fill")
        image.tintColor = .systemBlack
        image.clipsToBounds = true
        return image
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = nil
        image.layer.cornerRadius = 4
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.clipsToBounds = true
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setPrivacyViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setPrivacyViewLayout() {
        contentView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blurView.layer.cornerRadius = 4
        contentView.addSubview(lockImage)
        lockImage.translatesAutoresizingMaskIntoConstraints = false
        lockImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        lockImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        messageLabel.font = .systemFont(ofSize: 12, weight: .regular)
        fromLabel.font = .systemFont(ofSize: 10, weight: .bold)
    }
}

extension PostRollingPaperCollectionViewCell {
    func setupView() {
        containerView.removeFromSuperview()
        messageLabel.removeFromSuperview()
        fromLabel.removeFromSuperview()
        imageView.removeFromSuperview()
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        
        containerView.addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        fromLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        
        if imageView.image != nil {
            containerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 10).isActive = true
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50)/2).isActive = true
        }
        
    }
}

