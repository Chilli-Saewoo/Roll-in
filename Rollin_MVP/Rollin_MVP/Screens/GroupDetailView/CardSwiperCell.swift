//
//  CardSwiperCell.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/12/11.
//

import UIKit
import VerticalCardSwiper

final class CardSwiperCell: CardCell {
    private let nameLabel = UILabel()
    private let bookmarkLabel = UIImageView()
    private var emptyMessage: UILabel = {
        let label = UILabel()
        label.text = "아직 아무도 답장하지 않았어요"
        label.textColor = .systemBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    private let cardSkeleton = CardSkeletonView()
    
    public func setCell(index: Int, name: String, userId: String, postCount: Int?) {
        let colors: [UIColor] = [.cardBlue, .cardPink, .cardGreen, .cardPurple, .cardYellow]
        self.backgroundColor = colors[index % colors.count]
        self.layer.cornerRadius = 4.0
        setShadow()
        nameLabel.text = name
        if userId == UserDefaults.standard.string(forKey: "uid") {
            setBookMarkLabel()
        } else {
            bookmarkLabel.removeFromSuperview()
        }
        if postCount == 0 {
            setEmptyMessage()
            cardSkeleton.removeFromSuperview()
        } else {
            emptyMessage.removeFromSuperview()
            setCardSkeletonView()
        }
        cardSkeleton.setViews(count: postCount ?? 0)
    }
    
    private func setCardSkeletonView() {
        self.addSubview(cardSkeleton)
        cardSkeleton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardSkeleton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cardSkeleton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            cardSkeleton.topAnchor.constraint(equalTo: self.topAnchor, constant: 67),
            cardSkeleton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
        ])
    }
    
    private func setEmptyMessage() {
        self.addSubview(emptyMessage)
        emptyMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyMessage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            emptyMessage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
        ])
    }
    
    private func setShadow() {
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.layer.shadowPath = nil
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
        ])
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    private func setBookMarkLabel() {
        self.addSubview(bookmarkLabel)
        bookmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            bookmarkLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
        bookmarkLabel.image = UIImage(named: "bookmark")
    }
}

