//
//  CardSkeletonView.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/12/11.
//

import UIKit

final class SkeletonView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 4.0
        self.backgroundColor = .bgYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class CardSkeletonView: UIView {
    private let views = [SkeletonView(), SkeletonView(), SkeletonView(), SkeletonView(), SkeletonView(), SkeletonView()]
    private var heights: [CGFloat] {
        var res = [CGFloat]()
        for _ in 0 ..< 4 {
            res.append(CGFloat.random(in: 90 ... 240))
        }
        return res
    }
    private let colors: [UIColor] = [.skeletonRed, .skeletonBlue, .skeletonGreen, .skeletonYellow, .skeletonPurple]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setViews(count: Int) {
        var count = count
        if count > 6 {
            count = 6
        }
        for idx in 0 ..< views.count {
            views[idx].removeFromSuperview()
        }
        for idx in 0 ..< count {
            self.addSubview(views[idx])
            views[idx].translatesAutoresizingMaskIntoConstraints = false
            views[idx].backgroundColor = colors.randomElement()
        }
        if count >= 1 {
            NSLayoutConstraint.activate([
                views[0].topAnchor.constraint(equalTo: self.topAnchor),
                views[0].leadingAnchor.constraint(equalTo: self.leadingAnchor),
                views[0].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47),
                views[0].heightAnchor.constraint(equalToConstant: heights[0]),
            ])
        }
        if count >= 2 {
            NSLayoutConstraint.activate([
                views[1].topAnchor.constraint(equalTo: self.topAnchor),
                views[1].trailingAnchor.constraint(equalTo: self.trailingAnchor),
                views[1].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47),
                views[1].heightAnchor.constraint(equalToConstant: heights[1]),
            ])
        }
        if count >= 3 {
            NSLayoutConstraint.activate([
                views[2].topAnchor.constraint(equalTo: views[0].bottomAnchor, constant: 15),
                views[2].leadingAnchor.constraint(equalTo: self.leadingAnchor),
                views[2].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47),
                views[2].heightAnchor.constraint(equalToConstant: heights[2]),
            ])
        }
        if count >= 4 {
            NSLayoutConstraint.activate([
                views[3].topAnchor.constraint(equalTo: views[1].bottomAnchor, constant: 15),
                views[3].trailingAnchor.constraint(equalTo: self.trailingAnchor),
                views[3].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47),
                views[3].heightAnchor.constraint(equalToConstant: heights[3]),
            ])
        }
        if count >= 5 {
            NSLayoutConstraint.activate([
                views[4].topAnchor.constraint(equalTo: views[2].bottomAnchor, constant: 15),
                views[4].leadingAnchor.constraint(equalTo: self.leadingAnchor),
                views[4].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47),
                views[4].bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
        if count >= 6 {
            NSLayoutConstraint.activate([
                views[5].topAnchor.constraint(equalTo: views[3].bottomAnchor, constant: 15),
                views[5].trailingAnchor.constraint(equalTo: self.trailingAnchor),
                views[5].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47),
                views[5].bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
