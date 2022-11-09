//
//  WriteRollingPaperViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit
import AVFoundation
import Photos

final class WriteRollingPaperViewController: UIViewController {
    
    private let postThemePicerkView = PostThemePickerView()
    private let postView = PostView()
    private let imagePickerViewController = UIImagePickerController()
    private lazy var authorizationOfCameraAlert = makeAlert(title: "알림", message: "카메라 접근이 허용되어 있지 않습니다.")
    private lazy var authorizationOfLibraryAlert = makeAlert(title: "알림", message: "라이브러리 접근이 허용되어 있지 않습니다.")
    
    private let privateSwitch: UISwitch = {
        let privateSwitch = UISwitch()
        return privateSwitch
    }()
    
    private let privateSwitchTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹내 공개"
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButtonAction()
        postThemePicerkView.delegate = self
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
    }
    
    private func setImagePickerToPhotoLibrary() {
        imagePickerViewController.sourceType = .photoLibrary
        present(imagePickerViewController, animated: true)
    }
    
    private func setImagePickerToCamera() {
        imagePickerViewController.sourceType = .camera
        present(imagePickerViewController, animated: true)
    }
    
    private func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                DispatchQueue.main.async {
                    self.setImagePickerToCamera()
                }
            } else {
                DispatchQueue.main.async {
                    self.authorizationOfCameraAlert
                }
            }
        })
    }
    
    private func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.setImagePickerToPhotoLibrary()
                }
            case .denied:
                DispatchQueue.main.async {
                    self.authorizationOfLibraryAlert
                }
            default:
                break
            }
        })
    }
    
    private func setupButtonAction() {
        postView.imageButton.addTarget(self, action: #selector(touchUpInsideToSetPhoto), for: .touchUpInside)
    }
    
    @objc
    private func touchUpInsideToSetPhoto() {
        let choosePhotoFromAlbumAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.checkAlbumPermission()}
        let takePhotoAction: ((UIAlertAction) -> ()) = { [weak self] _ in
            self?.checkCameraPermission()}
        makeActionSheet(actionTitles: ["라이브러리에서 선택하기", "사진 촬영하기", "취소"],
                        actionStyle: [.default, .default, .cancel],
                        actions: [choosePhotoFromAlbumAction, takePhotoAction, nil])
    }
    
    private func setupLayout() {
        view.addSubview(postThemePicerkView)
        postThemePicerkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postThemePicerkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postThemePicerkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postThemePicerkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postThemePicerkView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(privateSwitch)
        privateSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateSwitch.topAnchor.constraint(equalTo: postThemePicerkView.bottomAnchor, constant: 8),
            privateSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        view.addSubview(privateSwitchTitleLabel)
        privateSwitchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privateSwitchTitleLabel.centerYAnchor.constraint(equalTo: privateSwitch.centerYAnchor),
            privateSwitchTitleLabel.trailingAnchor.constraint(equalTo: privateSwitch.leadingAnchor, constant: -8)
        ])
        
        view.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: privateSwitch.bottomAnchor, constant: 8),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
        ])
        
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            confirmButton.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
}


extension WriteRollingPaperViewController: PostViewDelegate {
    func changePostColor(selectedColor: UIColor) {
        postView.textView.backgroundColor = selectedColor
    }
}

extension WriteRollingPaperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            postView.imageButton.setBackgroundImage(image, for: .normal)
            postView.imageButton.layer.cornerRadius = 16
            postView.imageButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            postView.imageButton.clipsToBounds = true
            postView.imageButton.setTitle("", for: .normal)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
