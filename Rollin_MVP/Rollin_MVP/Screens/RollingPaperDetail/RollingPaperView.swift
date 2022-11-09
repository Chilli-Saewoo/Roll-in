//
//  RollingPaperView.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/09.
//

import UIKit

final class RollingPaperView: UIViewController {

    private lazy var detailRollingPaperButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
}

private extension RollingPaperView {
    func setDetailRollingPaperButton() {
        view.addSubview(detailRollingPaperButton)
        detailRollingPaperButton.translatesAutoresizingMaskIntoConstraints = false
        detailRollingPaperButton.setTitle("자세히 보기", for: .normal)
        
        NSLayoutConstraint.activate([
            detailRollingPaperButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            detailRollingPaperButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
    }
}
