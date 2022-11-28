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

    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        let myURL = URL(string:"https://mercury-comte-8e6.notion.site/ea8b9c2b9cfd469da4c70285362e6a28")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
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
