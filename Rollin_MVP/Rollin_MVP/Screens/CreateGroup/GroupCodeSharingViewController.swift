//
//  GroupCodeSharingViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

final class GroupCodeSharingViewController: UIViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    private lazy var titleMessageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTitleMessageLayout()
    }
}

private extension GroupCodeSharingViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        titleMessageLabel.text = "아래 코드를 공유해서\n롤링페이퍼를 시작해보세요"
        titleMessageLabel.numberOfLines = 0
        
    }
}
