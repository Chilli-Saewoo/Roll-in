//
//  WriteRollingPaperViewController.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit
import AVFoundation
import Photos

import FirebaseFirestore
import FirebaseStorage
import Firebase

final class WriteRollingPaperViewController: UIViewController {
    
    private let postThemePicerkView = PostThemePickerView()
    private let postView = PostView()
    private let imagePickerViewController = UIImagePickerController()
    private lazy var authorizationOfCameraAlert: () = makeAlert(title: "알림", message: "카메라 접근이 허용되어 있지 않습니다.")
    private lazy var authorizationOfPhotoLibraryAlert: () = makeAlert(title: "알림", message: "라이브러리 접근이 허용되어 있지 않습니다.")
    private let postThemePickerItemWidth = (UIScreen.main.bounds.width - (7 * 4) - (21 * 2))/5
    private let rollingPaperPostAPI = RollingPaperPostAPI()
    private var isBeingSaved: Bool = false
    private var postImage: UIImage = UIImage()
    var writerNickname: String = ""
    var groupId: String = ""
    var receiverUserId: String = ""
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("올리기", for: .normal)
        button.backgroundColor = .inactiveBgGray
        button.setTitleColor(.inactiveTextGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButtonAction()
        configureDelegate()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureDelegate() {
        postThemePicerkView.delegate = self
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        postView.delegate = self
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
                    self.authorizationOfPhotoLibraryAlert
                }
            default:
                break
            }
        })
    }
    
    private func setupButtonAction() {
        postView.emptyImageButton.addTarget(self, action: #selector(touchUpInsideToSetPhoto), for: .touchUpInside)
        postView.addedImageButton.addTarget(self, action: #selector(touchUpInsideToSetPhoto), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(touchUpInsideToConfirmPost), for: .touchUpInside)
        confirmButton.isEnabled = false
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
    
    @objc
    private func touchUpInsideToConfirmPost() {
        Task {
            if !isBeingSaved {
                isBeingSaved = true
                FirebaseStorageManager.uploadImage(image: postImage, pathRoot: receiverUserId) { url in
                    guard let url = url else { return }
                    let absoluteUrl = url.absoluteString
                    let rollingPaperPostData = RollingPaperPostData(from: self.writerNickname,
                                                                    postTheme: self.postThemePicerkView.selectedThemeHex,
                                                                    message: self.postView.textView.text,
                                                                    image: absoluteUrl,
                                                                    isPublic: self.postView.privateSwitch.isOn,
                                                                    timeStamp: Date())
                    
                    let rollingPaperPostAPI = RollingPaperPostAPI()
                    rollingPaperPostAPI.writePost(document: rollingPaperPostData,
                                                  imageUrl: absoluteUrl,
                                                  groupId: self.groupId,
                                                  receiver: self.receiverUserId)
                }
                isBeingSaved = false
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(postThemePicerkView)
        postThemePicerkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postThemePicerkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postThemePicerkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            postThemePicerkView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            postThemePicerkView.heightAnchor.constraint(equalToConstant: postThemePickerItemWidth + 25)
        ])
        
        postView.fromLabel.text = "From. \(writerNickname)"
        view.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: postThemePicerkView.bottomAnchor, constant: 43),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
    
    private func setupPostLayout() {
        view.addSubview(postView)
        postView.fromLabel.text = "From. \(writerNickname)"
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: postThemePicerkView.bottomAnchor, constant: 43),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postView.heightAnchor.constraint(equalToConstant: 164 + UIScreen.main.bounds.width - 40),
        ])
    }
}


extension WriteRollingPaperViewController: PostViewDelegate {
    func changePostColor(selectedTextColor: UIColor, selectedBgColor: UIColor) {
        postView.textView.textColor = selectedTextColor
        postView.textView.tintColor = selectedTextColor
        postView.textView.backgroundColor = selectedBgColor
        postView.fromLabel.textColor = selectedTextColor
    }
}

extension WriteRollingPaperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            if !postView.isPhotoAdded {
                postView.emptyImageButton.removeFromSuperview()
                postView.setupAddedImageButtonLayout()
                postView.removeFromSuperview()
                setupPostLayout()
                postView.isPhotoAdded = true
            }
            postView.addedImageButton.setBackgroundImage(image, for: .normal)
            postView.addedImageButton.layer.cornerRadius = 4
            postView.addedImageButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            postView.addedImageButton.clipsToBounds = true
            postImage = image
        }
        
        if postView.isTextEdited && postView.isPhotoAdded {
            activeConfirmButton()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension WriteRollingPaperViewController: WriteRollingPaperViewControllerDelegate {
    func activeConfirmButton() {
        confirmButton.backgroundColor = .systemBlack
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.isEnabled = true
    }
    
    func inactiveConfirmButton() {
        confirmButton.backgroundColor = .inactiveBgGray
        confirmButton.setTitleColor(.inactiveTextGray, for: .normal)
        confirmButton.isEnabled = false
    }
}
