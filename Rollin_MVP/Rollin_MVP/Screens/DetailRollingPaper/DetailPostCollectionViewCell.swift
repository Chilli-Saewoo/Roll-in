//
//  DetailPostCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/11.
//

import UIKit

final class DetailPostCollectionViewCell: UICollectionViewCell {
    var detailPostView = UIView()
    var message = UILabel()
    var image = UIImageView()
    var isPhoto: Bool = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDetailPostLayout()
    }
    
    private func setDetailPostLayout() {
        detailPostView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(detailPostView)
        NSLayoutConstraint.activate([
            detailPostView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            detailPostView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            detailPostView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailPostView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        if isPhoto {
            self.contentView.addSubview(image)
            image.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                image.topAnchor.constraint(equalTo: contentView.topAnchor),
                image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            self.contentView.addSubview(message)
            message.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                message.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            ])
//            self.contentView.addSubview(from)
//            from.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                from.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 5),
//                from.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//                from.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
//            ])
        }
    }
    func setBackgroundColor(color: UIColor?) {
        detailPostView.backgroundColor = color
    }
}
