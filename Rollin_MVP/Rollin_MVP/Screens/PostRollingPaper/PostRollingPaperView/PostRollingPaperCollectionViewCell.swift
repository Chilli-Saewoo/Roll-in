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

    var postRollingPaperModel: PostRollingPaperModel? {
        didSet {
            bind()
        }
    }
    
    lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.8
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

    lazy var PostRollingPaperContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()

    lazy var PostRollingPaperTitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var PostRollingPaperFromLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    lazy var PostRollingPaperImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "cat")
        image.layer.cornerRadius = 4
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.clipsToBounds = true
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func bind() {
        blurView.removeFromSuperview()
        lockImage.removeFromSuperview()
        PostRollingPaperContainerView.backgroundColor = postRollingPaperModel?.color
        PostRollingPaperImageView.image = postRollingPaperModel?.image
        PostRollingPaperTitleLabel.text = postRollingPaperModel?.commentString
        guard let from = postRollingPaperModel?.from else { return }
        PostRollingPaperFromLabel.text = "From. \(from)"
        guard let isPublic = postRollingPaperModel?.isPublic else { return }
        
        contentView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        if isPublic || receiverUserId == UserDefaults.standard.string(forKey: "uid") {
            blurView.layer.opacity = 0.0
        } else {
            blurView.layer.opacity = 1.0
            contentView.addSubview(lockImage)
            lockImage.translatesAutoresizingMaskIntoConstraints = false
            lockImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            lockImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        }
        PostRollingPaperTitleLabel.textColor = getTextColor()
        PostRollingPaperTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        PostRollingPaperFromLabel.textColor = getTextColor()
        PostRollingPaperFromLabel.font = .systemFont(ofSize: 10, weight: .bold)
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
        
        PostRollingPaperContainerView.addSubview(PostRollingPaperTitleLabel)
        PostRollingPaperTitleLabel.text = postRollingPaperModel?.commentString
        PostRollingPaperTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperTitleLabel.leadingAnchor.constraint(equalTo: PostRollingPaperContainerView.leadingAnchor, constant: 10).isActive = true
        PostRollingPaperTitleLabel.topAnchor.constraint(equalTo: PostRollingPaperContainerView.topAnchor, constant: 10).isActive = true
        PostRollingPaperTitleLabel.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor, constant: -10).isActive = true
        
        PostRollingPaperContainerView.addSubview(PostRollingPaperFromLabel)
        PostRollingPaperFromLabel.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperFromLabel.topAnchor.constraint(equalTo: PostRollingPaperTitleLabel.bottomAnchor, constant: 10).isActive = true
        PostRollingPaperFromLabel.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor, constant: -10).isActive = true
        
        PostRollingPaperContainerView.addSubview(PostRollingPaperImageView)
        PostRollingPaperImageView.translatesAutoresizingMaskIntoConstraints = false
        PostRollingPaperImageView.topAnchor.constraint(equalTo: PostRollingPaperFromLabel.bottomAnchor, constant: 10).isActive = true
        PostRollingPaperImageView.leadingAnchor.constraint(equalTo: PostRollingPaperContainerView.leadingAnchor).isActive = true
        PostRollingPaperImageView.bottomAnchor.constraint(equalTo: PostRollingPaperContainerView.bottomAnchor).isActive = true
        PostRollingPaperImageView.trailingAnchor.constraint(equalTo: PostRollingPaperContainerView.trailingAnchor).isActive = true
        PostRollingPaperImageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50)/2).isActive = true
        
    }
    
    func getTextColor() -> UIColor {
        guard let backgroundColor = postRollingPaperModel?.colorHex else { return .black }
        print(backgroundColor)
        switch backgroundColor  {
        case "FFFCDD":
            return hexStringToUIColor(hex: "9E6003")
        case "FEE0EA":
            return hexStringToUIColor(hex: "D61951")
        case "EBDDFF":
            return hexStringToUIColor(hex: "4D2980")
        case "DDEBFF":
            return hexStringToUIColor(hex: "4069CE")
        case "C8F6D5":
            return hexStringToUIColor(hex: "15843B")
        default:
            return hexStringToUIColor(hex: "9E6003")
        }
    }
}

