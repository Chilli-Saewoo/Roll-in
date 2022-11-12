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

    lazy var PostRollingPaperContainerView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var PostRollingPaperTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var PostRollingPaperImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "cat")
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
        PostRollingPaperImageView.image = myModel?.imageString
        PostRollingPaperTitleLabel.text = myModel?.commentString
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
    
        
//        containerView.addSubview(PostRollingPaperImageView)
//        PostRollingPaperImageView.translatesAutoresizingMaskIntoConstraints = false
//        PostRollingPaperImageView.leadingAnchor.constraint(equalTo: PostRollingPaperContainerView.leadingAnchor).isActive = true
//        PostRollingPaperImageView.bottomAnchor.constraint(equalTo: PostRollingPaperContainerView.bottomAnchor).isActive = true
//        PostRollingPaperImageView.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor).isActive = true
        
        PostRollingPaperContainerView.addSubview(PostRollingPaperTitleLabel)
        PostRollingPaperTitleLabel.text = myModel?.commentString
        PostRollingPaperTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperTitleLabel.leadingAnchor.constraint(equalTo: PostRollingPaperContainerView.leadingAnchor).isActive = true
        PostRollingPaperTitleLabel.topAnchor.constraint(equalTo: PostRollingPaperContainerView.topAnchor).isActive = true
        PostRollingPaperTitleLabel.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor).isActive = true
    }
}

