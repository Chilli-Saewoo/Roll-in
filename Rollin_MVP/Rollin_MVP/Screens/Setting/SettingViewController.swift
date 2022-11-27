//
//  SettingViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/27.
//

import UIKit

final class SettingViewController: UIViewController {
    
    enum SettingTitle: String {
        case setNickname = "닉네임 설정"
        case privacyPolicy = "개인정보 보호정책"
        case openLicense = "오픈소스 라이선스"
        case mailToDeveloper = "개발제에게 의견 남기기"
        case logout = "로그아웃"
        case signout = "회원탈퇴"
    }
    
    private let settingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 60
        return tableView
    }()
    
    private let settingTitleList: [SettingTitle] = [.setNickname, .privacyPolicy, .openLicense, .mailToDeveloper, .logout, .signout]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureDelegate()
    }
    
    private func configureDelegate() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.className)
    }
    
    private func setupLayout() {
        view.addSubview(settingTitleLabel)
        settingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(settingTableView)
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: settingTitleLabel.bottomAnchor, constant: 7),
            settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.className) as? SettingTableViewCell else { return UITableViewCell() }
        
        switch settingTitleList[indexPath.row] {
        case .logout:
            cell.configureUI(title: settingTitleList[indexPath.row].rawValue, isArrowHidden: true, isRed: false)
        case .signout:
            cell.configureUI(title: settingTitleList[indexPath.row].rawValue, isArrowHidden: true, isRed: true)
        default:
            cell.configureUI(title: settingTitleList[indexPath.row].rawValue, isArrowHidden: false, isRed: false)
        }
        return cell
    }
    
    
}
