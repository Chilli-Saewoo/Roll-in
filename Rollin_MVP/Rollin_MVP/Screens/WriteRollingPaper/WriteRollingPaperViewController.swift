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
    
//    private let postThemePicerkView = PostThemePickerView()
    private let postView = PostView()
//    private let imagePickerViewController = UIImagePickerController()
//    private let rollingPaperPostAPI = RollingPaperPostAPI()
//    private let postThemePickerItemWidth = (UIScreen.main.bounds.width - (7 * 4) - (21 * 2))/5
    
//    private lazy var authorizationOfCameraAlert: () = makeAlert(title: "알림", message: "카메라 접근이 허용되어 있지 않습니다.")
//    private lazy var authorizationOfPhotoLibraryAlert: () = makeAlert(title: "알림", message: "라이브러리 접근이 허용되어 있지 않습니다.")
//    private var isBeingSaved: Bool = false
//    private var postImage: UIImage = UIImage()
    var writerNickname: String = ""
    var groupId: String = ""
    var receiverUserId: String = ""
    
//    private let buttonStackView: UIStackView = {
//
//    }()
//
//    private let templateButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("템플릿", for: .normal)
//        return button
//    }()
//
//    private let photoButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("사진", for: .normal)
//        return button
//    }()
    
//    private let confirmButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("올리기", for: .normal)
//        button.backgroundColor = .inactiveBgGray
//        button.setTitleColor(.inactiveTextGray, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
//        button.layer.cornerRadius = 4
//        return button
//    }()
    
//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.center = self.view.center
//        activityIndicator.style = UIActivityIndicatorView.Style.large
//        activityIndicator.startAnimating()
//        activityIndicator.isHidden = false
//        activityIndicator.color = .white
//        return activityIndicator
//    }()
    
//    private var activityIndicatorLabel: UILabel = {
//        let label = UILabel()
//        label.text = "올라가고 있어요"
//        label.textColor = .white
//        label.font = .systemFont(ofSize: 24, weight: .bold)
//        return label
//    }()
    
//    lazy var activityIndicatorBackgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.layer.opacity = 0.3
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWholeLayout()
//        setupButtonAction()
        configureDelegate()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureDelegate() {
//        postThemePicerkView.delegate = self
//        imagePickerViewController.delegate = self
//        imagePickerViewController.allowsEditing = true
//        postView.delegate = self
    }
    
//    private func setImagePickerToPhotoLibrary() {
//        imagePickerViewController.sourceType = .photoLibrary
//        present(imagePickerViewController, animated: true)
//    }
//
//    private func setImagePickerToCamera() {
//        imagePickerViewController.sourceType = .camera
//        present(imagePickerViewController, animated: true)
//    }
//
//    private func checkCameraPermission() {
//        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
//            if granted {
//                DispatchQueue.main.async {
//                    self.setImagePickerToCamera()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.authorizationOfCameraAlert
//                }
//            }
//        })
//    }
//
//    private func checkAlbumPermission() {
//        PHPhotoLibrary.requestAuthorization({ [weak self] status in
//            guard let self = self else { return }
//            switch status {
//            case .authorized:
//                DispatchQueue.main.async {
//                    self.setImagePickerToPhotoLibrary()
//                }
//            case .denied:
//                DispatchQueue.main.async {
//                    self.authorizationOfPhotoLibraryAlert
//                }
//            default:
//                break
//            }
//        })
//    }
    
//    private func setupButtonAction() {
//        postView.emptyImageButton.addTarget(self, action: #selector(touchUpInsideToSetPhoto), for: .touchUpInside)
//        postView.addedImageButton.addTarget(self, action: #selector(touchUpInsideToSetPhoto), for: .touchUpInside)
//        confirmButton.addTarget(self, action: #selector(touchUpInsideToConfirmPost), for: .touchUpInside)
//        confirmButton.isEnabled = false
//    }
    
//    @objc
//    private func touchUpInsideToSetPhoto() {
//        let choosePhotoFromAlbumAction: ((UIAlertAction) -> ()) = { [weak self] _ in
//            self?.checkAlbumPermission()}
//        let takePhotoAction: ((UIAlertAction) -> ()) = { [weak self] _ in
//            self?.checkCameraPermission()}
//        makeActionSheet(actionTitles: ["라이브러리에서 선택하기", "사진 촬영하기", "취소"],
//                        actionStyle: [.default, .default, .cancel],
//                        actions: [choosePhotoFromAlbumAction, takePhotoAction, nil])
//    }
//
//    @objc
//    private func touchUpInsideToConfirmPost() {
//        Task {
//            if !isBeingSaved {
//                isBeingSaved = true
//                setupActivityIndicatorLayout()
//                FirebaseStorageManager.uploadImage(image: postImage, pathRoot: receiverUserId) { url in
//                    guard let url = url else { return }
//                    let absoluteUrl = url.absoluteString
//                    let rollingPaperPostData = PostWithImageAndMessage(type: .imageAndMessage, id: "", timestamp: Date(), from: self.writerNickname, isPublic: self.postView.privateSwitch.isOn, imageURL: absoluteUrl, message: self.postView.textView.text, postTheme: self.postThemePicerkView.selectedThemeHex)
//
//                    let rollingPaperPostAPI = RollingPaperPostAPI()
//                    rollingPaperPostAPI.writePost(document: rollingPaperPostData,
//                                                  imageUrl: absoluteUrl,
//                                                  groupId: self.groupId,
//                                                  receiver: self.receiverUserId)
//                    self.isBeingSaved = false
//                    self.activityIndicator.stopAnimating()
//                    _ = self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
//    }
    
    private func setupWholeLayout() {
        setupPostLayout()
        
//        view.addSubview(buttonStackView)
//        
//        view.addSubview(templateButton)
//        templateButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint =
//        
//        view.addSubview(photoButton)
//        photoButton.translatesAutoresizingMaskIntoConstraints = false
//                view.addSubview(postThemePicerkView)
//                postThemePicerkView.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    postThemePicerkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                    postThemePicerkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
//                    postThemePicerkView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
//                    postThemePicerkView.heightAnchor.constraint(equalToConstant: postThemePickerItemWidth + 25)
//                ])
        
//        view.addSubview(confirmButton)
//        confirmButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
//            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            confirmButton.heightAnchor.constraint(equalToConstant: 57)
//        ])
    }
    
    private func setupPostLayout() {
        view.addSubview(postView)
        postView.writerNickname = writerNickname
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            postView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
//        if postView.isPhotoAdded {
//            NSLayoutConstraint.activate([
//                postView.heightAnchor.constraint(equalToConstant: 164 + UIScreen.main.bounds.width - 40),
//            ])
//        }
    }
    
//    private func setupActivityIndicatorLayout() {
//        view.addSubview(activityIndicatorBackgroundView)
//        activityIndicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            activityIndicatorBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//            activityIndicatorBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            activityIndicatorBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            activityIndicatorBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
//
//        view.addSubview(activityIndicator)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//
//        view.addSubview(activityIndicatorLabel)
//        activityIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            activityIndicatorLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
//            activityIndicatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//
//    }
}


//extension WriteRollingPaperViewController: PostViewDelegate {
//    func changePostColor(selectedTextColor: UIColor, selectedBgColor: UIColor) {
//        postView.textView.textColor = selectedTextColor
//        postView.textView.tintColor = selectedTextColor
//        postView.textView.backgroundColor = selectedBgColor
//        postView.fromLabel.textColor = selectedTextColor
//    }
//}

extension WriteRollingPaperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
//            if !postView.isPhotoAdded {
//                postView.emptyImageButton.removeFromSuperview()
//                postView.setupAddedImageButtonLayout()
//                postView.removeFromSuperview()
//                postView.isPhotoAdded = true
//                setupPostLayout()
//            }
//            postView.addedImageButton.setBackgroundImage(image, for: .normal)
//            postView.addedImageButton.layer.cornerRadius = 4
//            postView.addedImageButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//            postView.addedImageButton.clipsToBounds = true
//            postImage = image
//        }
//
//        if postView.isTextEdited && postView.isPhotoAdded {
//            activeConfirmButton()
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
}

//extension WriteRollingPaperViewController: WriteRollingPaperViewControllerDelegate {
//    func activeConfirmButton() {
//        confirmButton.backgroundColor = .systemBlack
//        confirmButton.setTitleColor(.white, for: .normal)
//        confirmButton.isEnabled = true
//    }
//
//    func inactiveConfirmButton() {
//        confirmButton.backgroundColor = .inactiveBgGray
//        confirmButton.setTitleColor(.inactiveTextGray, for: .normal)
//        confirmButton.isEnabled = false
//    }
//}

