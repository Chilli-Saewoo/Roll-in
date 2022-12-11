//
//  SettingViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/27.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MessageUI

final class SettingViewController: UIViewController {
    
    enum SettingTitle: String {
        case setNickname = "계정명 설정"
        case privacyPolicy = "개인정보 보호정책"
        case openLicense = "오픈소스 라이선스"
        case mailToDeveloper = "개발자에게 의견 남기기"
        case logout = "로그아웃"
        case signout = "회원탈퇴"
    }
    
    private let db = Firestore.firestore()
    
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
            touchUpInsideToMailToDeveloperPage()
        case .logout:
            let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "로그아웃하기", style: .destructive, handler: {_ in
                try! FirebaseAuth.Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                let navigationController = UINavigationController(rootViewController: vc)
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let delegate = sceneDelegate else {
                    return
                }
                delegate.window?.rootViewController = navigationController
            })
            let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        case .signout:
            let alert = UIAlertController(title: "회원탈퇴 하시겠습니까?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "회원탈퇴하기", style: .destructive, handler: {_ in
                if let uid = UserDefaults.standard.string(forKey: "uid") {
                    // userGroups에 해당하는 user_uid값을 체크하고 현재 참여중인 그룹을 확인
                    let docRef = self.db.collection("userGroups").document(uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let groupIds = document.data().map{
                                $0["division"] as? [String] ?? []
                            } ?? [String]()
                            for idx in 0..<groupIds.count {
                                let groupsRef = self.db.collection("groups").document(groupIds[idx])
                                groupsRef.getDocument(as: Group.self) { result in
                                    switch result {
                                    case .success(let group):
                                        //  그 뒤에 GroupUsers에서 해당하는 그룹 group_UUID를 체크 한 후 participants에 들어가서 해당하는 user_uid값 삭제
                                        self.db.collection("groupUsers").document(groupIds[idx]).collection("participants").getDocuments() { querySnapshot, error in
                                            if let err = error {
                                                print("Error getting documents: \(err)")
                                            } else {
                                                group.participants = []
                                                for _ in querySnapshot?.documents ?? [] {
                                                    self.db.collection("groupUsers").document(groupIds[idx]).collection("participants").document(UserDefaults.standard.string(forKey: "uid") ?? "").delete()
                                                    self.db.collection("groupUsers").document(groupIds[idx]).collection("participants").getDocuments { querySnapshot, error in
                                                        if let err = error {
                                                            print("Error getting documents: \(err)")
                                                        } else {
                                                            guard let docs = querySnapshot?.documents else { return }
                                                            if docs.count == 0 {
                                                                self.db.collection("groupUsers").document(groupIds[idx]).delete()
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                                self.db.collection("userGroups").document(UserDefaults.standard.string(forKey: "uid") ?? "").delete()
                                                self.db.collection("users").document(UserDefaults.standard.string(forKey: "uid") ?? "").delete()
                                                UserDefaults.standard.removeObject(forKey: "uid")
                                            }
                                        }
                                    case .failure(let error):
                                        print("Error decoding group: \(error)")
                                    }
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                let navigationController = UINavigationController(rootViewController: vc)
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let delegate = sceneDelegate else {
                    return
                }
                delegate.window?.rootViewController = navigationController
            })
            let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
    
    func touchUpInsideToMailToDeveloperPage() {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
                let bodyString = """
                                 문의 내용을 입력해주세요
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
