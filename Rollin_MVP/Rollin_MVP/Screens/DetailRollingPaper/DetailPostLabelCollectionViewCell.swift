//
//  DetailPostCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/11.
//

import UIKit

final class DetailPostLabelCollectionViewCell: UICollectionViewCell {
    var detailPostView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    var detailPostThemeView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = nil
        image.layer.cornerRadius = 7
        image.clipsToBounds = true
        return image
    }()
    
    var message: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    var from: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDetailPostLayout()
    }
    
    private func setDetailPostLayout() {
        self.contentView.addSubview(detailPostView)
        detailPostView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailPostView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            detailPostView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            detailPostView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailPostView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        self.contentView.addSubview(detailPostThemeView)
        detailPostThemeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailPostThemeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            detailPostThemeView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            detailPostThemeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailPostThemeView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        self.contentView.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.numberOfLines = 0
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
        
        self.contentView.addSubview(from)
        from.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            from.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            from.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
        ])
    }
    
    func setBackgroundColor(color: UIColor?) {
        detailPostView.backgroundColor = color
    }
}
