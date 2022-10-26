//
//  QRCodeEnrollViewController.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/22.
//

import UIKit

final class QRCodeEnrollViewController: UIViewController {
    private let qrImageView = UIImageView()
    private let filter = CIFilter(name: "CIQRCodeGenerator")
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureQRImageView()
        configureLabelsView()
        configureStartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userId = UserDefaults.userId else { return }
        let url = "https://chilli-saewoo.github.io/rollin.github.io/write/id=" + userId
        setQRCodeImage(url)
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "RollingPaperVC") ?? UIViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    // https://gyuios.tistory.com/78
    private func setQRCodeImage(_ string: String) {
        guard let filter = filter, let data = string.data(using: .isoLatin1, allowLossyConversion: false) else { return }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let ciImage = filter.outputImage else { return }
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        if let ouputImage = alphaFilter?.outputImage {
            qrImageView.tintColor = .white
            qrImageView.backgroundColor = .black
            qrImageView.image = UIImage(ciImage: ouputImage, scale: 2.0, orientation: .up).withRenderingMode(.alwaysTemplate)
        } else { return }
    }
}

private extension QRCodeEnrollViewController {
    func configureQRImageView() {
        view.addSubview(qrImageView)
        setQRImageViewLayout()
    }
    
    func setQRImageViewLayout() {
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 176),
            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 215),
            qrImageView.heightAnchor.constraint(equalToConstant: 215),
        ])
    }
}

private extension QRCodeEnrollViewController {
    func configureLabelsView() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        setTitleLabelLayout()
        setDescriptionLabelLayout()
        guard let nickname = UserDefaults.nickname else { return }
        titleLabel.text = "\(nickname)님의 QR 코드 생성 완료"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        descriptionLabel.text = "누구나 \(nickname)께 롤링페이퍼를 전송할 수 있어요 \n QR을 공유해서 롤링페이퍼를 받아보세요"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
    }
    
    func setTitleLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 41),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setDescriptionLabelLayout() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
}

private extension QRCodeEnrollViewController {
    func configureStartButton() {
        view.addSubview(startButton)
        setStartButtonLayout()
        startButton.setTitle("시작하기", for: .normal)
        startButton.backgroundColor = .orange
        startButton.layer.cornerRadius = 16.0
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    func setStartButtonLayout() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            startButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

