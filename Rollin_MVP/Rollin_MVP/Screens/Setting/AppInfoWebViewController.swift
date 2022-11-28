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
