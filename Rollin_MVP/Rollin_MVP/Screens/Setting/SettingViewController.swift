//
//  SettingViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/27.
//

import UIKit
import MessageUI

final class SettingViewController: UIViewController {
    
    enum SettingTitle: String {
        case setNickname = "닉네임 설정"
        case privacyPolicy = "개인정보 보호정책"
        case openLicense = "오픈소스 라이선스"
        case mailToDeveloper = "개발자에게 의견 남기기"
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
        setNavigationBarBackButton()
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
            settingTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
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

    func appInfoCellPressed(webURL: String) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoWebViewController") as? AppInfoWebViewController {
            viewController.webURL = webURL
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingTableView.deselectRow(at: indexPath, animated: true)
        
        switch settingTitleList[indexPath.row] {
        case .setNickname:
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetNicknameViewController") as? ResetNicknameViewController ?? UIViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        case .privacyPolicy:
            appInfoCellPressed(webURL: "https://mercury-comte-8e6.notion.site/ea8b9c2b9cfd469da4c70285362e6a28")
        case .openLicense:
            appInfoCellPressed(webURL: "https://mercury-comte-8e6.notion.site/1fe800c1beb94913b278e9a690d914bd")
        case .mailToDeveloper:
            touchUpInsideMailToDeveloperPage()
        case .logout:
            //TODO: 추후 로그아웃 들어갈 예정
            print("logout")
        case .signout: break
            //TODO: 추후 회원탈퇴 로직 들어갈 예정
            }
        }
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

private extension SettingViewController {
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func touchUpInsideMailToDeveloperPage() {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
                let bodyString = """
                                 - 문의 내용
                                 """
                
                composeViewController.setToRecipients(["chillijo2022@gmail.com"])
                composeViewController.setSubject("[문의]")
                composeViewController.setMessageBody(bodyString, isHTML: false)
                
                self.present(composeViewController, animated: true, completion: nil)
            } else {
                print("메일 보내기 실패")
                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                    // 앱스토어로 이동하기(Mail)
                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                
                sendMailErrorAlert.addAction(goAppStoreAction)
                sendMailErrorAlert.addAction(cancleAction)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
