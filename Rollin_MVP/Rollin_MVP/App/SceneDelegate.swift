//
//  SceneDelegate.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let db = Firestore.firestore()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        try! FirebaseAuth.Auth.auth().signOut()
        if let user = FirebaseAuth.Auth.auth().currentUser {
            UserDefaults.standard.set(user.email ?? "", forKey: "userEmail")
            UserDefaults.standard.set(user.uid, forKey: "uid")
            let userRef = self.db.collection("users").document(UserDefaults.standard.string(forKey: "uid") ?? "")
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    UserDefaults.standard.set(document.data()?["usernickname"] ?? "익명의 유저", forKey: "nickname")
                    print("로그인 되어 있음", user.email ?? "-")
                    let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
                    let navigation = UINavigationController(rootViewController: vc)
                    self.window?.rootViewController = navigation
                    self.window?.makeKeyAndVisible()
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let navigation = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = navigation
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

