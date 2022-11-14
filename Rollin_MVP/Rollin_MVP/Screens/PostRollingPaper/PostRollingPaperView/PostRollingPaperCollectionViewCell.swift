//
//  PostRollingPaperCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

class PostRollingPaperCollectionViewCell: UICollectionViewCell {

    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }

    var myModel: PostRollingPaperModel? {
        didSet { bind() }
    }
    
    lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.8
        return visualEffectView
    }()
    
    lazy var lockImage: UIImage = {
        let image = UIImage()
        return image
    }()

    lazy var PostRollingPaperContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()

    lazy var PostRollingPaperTitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakStrategy = .hangulWordPriority
        label.numberOfLines = 0
        return label
    }()
    
    lazy var PostRollingPapeFromLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    lazy var PostRollingPaperImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "cat")
        image.layer.cornerRadius = 4
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func bind() {
        PostRollingPaperContainerView.backgroundColor = myModel?.color
        PostRollingPaperImageView.image = myModel?.image
        PostRollingPaperTitleLabel.text = myModel?.commentString
        guard let from = myModel?.from else { return }
        PostRollingPapeFromLabel.text = "From. \(from)"
        guard let isPublic = myModel?.isPublic else { return }
        var receiverUserId: String?
        if isPublic != true{
            contentView.addSubview(blurView)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
    }
}

private extension PostRollingPaperCollectionViewCell {
    private func setupView() {
        contentView.addSubview(PostRollingPaperContainerView)
        PostRollingPaperContainerView.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        PostRollingPaperContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        PostRollingPaperContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        PostRollingPaperContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        PostRollingPaperContainerView.addSubview(PostRollingPaperImageView)
        PostRollingPaperImageView.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperImageView.leadingAnchor.constraint(equalTo: PostRollingPaperContainerView.leadingAnchor).isActive = true
        PostRollingPaperImageView.bottomAnchor.constraint(equalTo: PostRollingPaperContainerView.bottomAnchor).isActive = true
        PostRollingPaperImageView.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor).isActive = true
        
        PostRollingPaperContainerView.addSubview(PostRollingPaperTitleLabel)
        PostRollingPaperTitleLabel.text = myModel?.commentString
        PostRollingPaperTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperTitleLabel.leadingAnchor.constraint(equalTo: PostRollingPaperContainerView.leadingAnchor, constant: 10).isActive = true
        PostRollingPaperTitleLabel.topAnchor.constraint(equalTo: PostRollingPaperContainerView.topAnchor, constant: 10).isActive = true
        PostRollingPaperTitleLabel.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor, constant: -10).isActive = true
        
        PostRollingPaperContainerView.addSubview(PostRollingPapeFromLabel)
        PostRollingPapeFromLabel.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPapeFromLabel.topAnchor.constraint(equalTo: PostRollingPaperTitleLabel.bottomAnchor, constant: 10).isActive = true
        PostRollingPapeFromLabel.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor, constant: -10).isActive = true
    }
}

