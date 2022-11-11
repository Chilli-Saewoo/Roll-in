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
    private let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppleButtonLayout()
    }
    
    // Unhashed nonce.
    private var currentNonce: String?
    
    @available(iOS 13, *)
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
    
    @available(iOS 13, *)
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
    func setupAppleButtonLayout() {
        view.addSubview(appleButton)
        appleButton.cornerRadius = 12
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 235).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
    }
}


@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func emailCheck(email: String) -> Bool {
            var result = false
            
            let userDB = db.collection("users")
            // 입력한 이메일이 있는지 확인 쿼리
            let query = userDB.whereField("email", isEqualTo: email)
            query.getDocuments() { (qs, err) in
                
                if qs!.documents.isEmpty {
                    print("데이터 중복 안 됨 가입 진행 가능")
                    result = true
                } else {
                    print("데이터 중복 됨 가입 진행 불가")
                    result = false
                }
            }
            
            return result
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
            print(credential)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    print("Error!!!!!!!")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("not logined")
                    return }
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.set(uid, forKey: "uid")

                print(uid)
                print(email)
                if self.emailCheck(email: email) == true {
                    self.db.collection("users").document(uid).setData([
                        "email": email,
                        "uid": uid,
                        "usernickname": displayName
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("the user has sign up or is logged in")
                            guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetNicknameWhileLoginViewController") else {return}
                                    
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                } else {
                    print("이메일 중복")
                    guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") else {return}
                            
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


