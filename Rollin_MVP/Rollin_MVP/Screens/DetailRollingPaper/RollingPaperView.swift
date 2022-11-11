//
//  RollingPaperView.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/11.
//

import UIKit

final class RollingPaperView: UIViewController, UISheetPresentationControllerDelegate {

    private lazy var detailRollingPaperButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetailRollingPaperButton()
        detailRollingPaperButton.addTarget(self, action: #selector(presentDetailViewHalfModal), for: .touchUpInside)
    }
    
    @objc private func presentDetailViewHalfModal() {
        
        let rollingPaperDetailViewController = DetailRollingPaperViewController()
        rollingPaperDetailViewController.view.backgroundColor = .gray
        rollingPaperDetailViewController.modalPresentationStyle = .pageSheet
        
        if let halfModal = rollingPaperDetailViewController.sheetPresentationController {
            halfModal.preferredCornerRadius = 10
            halfModal.detents = [.medium()]
            halfModal.delegate = self
            halfModal.prefersGrabberVisible = true
        }
        
        present(rollingPaperDetailViewController, animated: true, completion: nil)
    }
}

private extension RollingPaperView {
    func setDetailRollingPaperButton() {
        view.addSubview(detailRollingPaperButton)
        detailRollingPaperButton.translatesAutoresizingMaskIntoConstraints = false
        detailRollingPaperButton.setTitle("자세히 보기", for: .normal)
        
        NSLayoutConstraint.activate([
            detailRollingPaperButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
}
