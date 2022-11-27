//
//  LoginViewController.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

final class LoginViewController: UIViewController {
    let db = Firestore.firestore()
    private lazy var titleMessageLabel = UILabel()
    private let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppleButtonLayout()
        setAppleLoginButtonAction()
        setTitleMessageLayout()
    }
    
    private var currentNonce: String?
    
    private func setAppleLoginButtonAction() {
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
    }
    
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

private extension LoginViewController {
    func setTitleMessageLayout() {
        view.addSubview(titleMessageLabel)
        titleMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        titleMessageLabel.setTextWithLineHeight(text: "간편하게 로그인하고\n롤링페이퍼를 이용해보세요", lineHeight: 40)
        titleMessageLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleMessageLabel.numberOfLines = 0
        
    }
    
    func setupAppleButtonLayout() {
        view.addSubview(appleButton)
        appleButton.cornerRadius = 4
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
    }
}


extension LoginViewController: ASAuthorizationControllerDelegate {
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func emailCheck(email: String, uid: String) {
        let userDB = db.collection("users")
        // 입력한 이메일이 있는지 확인 쿼리
        let query = userDB.whereField("email", isEqualTo: email)
        query.getDocuments() { (qs, err) in
            if qs!.documents.isEmpty {
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetNicknameWhileLoginViewController") else {return}
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                print("데이터 중복 됨 가입 진행 불가")
                print("해당 이메일은 이미 가입이 되어있습니다.")
                let userRef = self.db.collection("users").document(UserDefaults.standard.string(forKey: "uid") ?? "")
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        UserDefaults.standard.set(document.data()?["usernickname"] ?? "익명의 유저", forKey: "nickname")
                    } else {
                        print("Document does not exist")
                    }
                }
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") else {return}
                self.navigationController?.pushViewController(viewController, animated: true)
                self.changeRootViewController()
            }
        }
    }
    
    private func changeRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainView")
        let navigationController = UINavigationController(rootViewController: vc)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            return
        }
        delegate.window?.rootViewController = navigationController
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("not logined")
                    return }
                // uerdefault에 email과 uid값 저장
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.set(uid, forKey: "uid")
                self.emailCheck(email: email, uid: uid)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


