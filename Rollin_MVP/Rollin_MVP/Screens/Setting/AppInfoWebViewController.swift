//
//  AppInfoWebViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/28.
//

import UIKit
import WebKit

final class AppInfoWebViewController: UIViewController {
    var webView: WKWebView!
    var webURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        let AppInfoURL = URL(string: webURL)
        let AppInfoRequest = URLRequest(url: AppInfoURL!)
        webView.load(AppInfoRequest)
        setWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           guard Reachability.networkConnected() else {
               let alert = UIAlertController(title: "NetworkError", message: "네트워크가 연결되어있지 않습니다.", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "닫기", style: .default) {  _ in
               }
               alert.addAction(okAction)
               self.present(alert, animated: true, completion: nil)
               return
           }
           
    }
}

private extension AppInfoWebViewController {
    func setWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: view.widthAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
}
