//
//  DetailPostCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/11.
//

import UIKit

final class DetailPostCollectionViewCell: UICollectionViewCell {
    static let id = "DetailPostCollectionViewCell"
    
    private let detailPostView = UIView()
    
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
    }
}
