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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureQRImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userId = UserDefaults.userId else { return }
        let url = "https://chilli-saewoo.github.io/rollin.github.io/write?id=" + userId
        setQRCodeImage(url)
    }
    
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
