//
//  MainViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/08.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainTitleLabel = UILabel()
    private let addGroupCard = AddGroupButtonBackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setMainTitleLabel()
        setAddGroupCard()
        addGroupCard.delegate = self
    }
}

extension MainViewController: AddGroupButtonBackgroundDelegate {
    func createActionSelected() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetTheme") as? SetThemeViewController ?? UIViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func showActionSheet(sheet: UIAlertController) {
        present(sheet, animated: true, completion: nil)
    }
    
    
}

private extension MainViewController {
    func setMainTitleLabel() {
        view.addSubview(mainTitleLabel)
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
        ])
        mainTitleLabel.font = .systemFont(ofSize: 26, weight: .medium)
        mainTitleLabel.text = "\("Key")의 롤링페이퍼"
    }
    
    
    func setAddGroupCard() {
        view.addSubview(addGroupCard)
        addGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addGroupCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addGroupCard.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 40),
            addGroupCard.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}


