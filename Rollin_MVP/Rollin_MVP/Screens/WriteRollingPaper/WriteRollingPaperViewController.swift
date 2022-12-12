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

protocol WriteRollingPaperViewDelegate: AnyObject {
    func activeConfirmButton()

    func inactiveConfirmButton()
    
    func presentImagePickerViewController(imageViewController: UIImagePickerController)
    
    func presentAlert(alertViewController: UIAlertController)
}

final class WriteRollingPaperViewController: UIViewController {
    
    private let postThemePicerkView = PostThemePickerView()
    private let postPhotoPickerView = PostPhotoPickerView()
    private let postView = PostView()
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.inactiveTextGray, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .inactiveBgGray
        return button
    }()
    
    private var isBeingSaved: Bool = false
    var writerNickname: String = ""
    var groupId: String = ""
    var receiverUserId: String = ""
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let templateButton: UIButton = {
        let button = UIButton()
        button.setTitle("템플릿", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let photoButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let underbarUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private var isTemplateView: Bool = true
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    private var activityIndicatorLabel: UILabel = {
        let label = UILabel()
        label.text = "올라가고 있어요"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    lazy var activityIndicatorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWholeLayout()
        setupButtonAction()
        configureDelegate()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureDelegate() {
        postThemePicerkView.postViewDelegate = postView
        postPhotoPickerView.postViewDelegate = postView
        postPhotoPickerView.delegate = self
        postView.delegate = self
    }
    
    private func setupButtonAction() {
        templateButton.addTarget(self, action: #selector(touchUpInsideToSetTemplateView), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(touchUpInsideToSetPhotoView), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(touchUpInsideToConfirmPost), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(touchUpInsideToDismiss), for: .touchUpInside)
    }
    
    @objc
    private func touchUpInsideToDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func touchUpInsideToSetTemplateView() {
        if !isTemplateView {
            isTemplateView.toggle()
            underbarUIView.removeFromSuperview()
            setupUnderbarViewLayout()
            postPhotoPickerView.removeFromSuperview()
            setupPostThemePickerViewLayout()
            postView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            postView.setFirstDotLayout()
        }
    }
    
    @objc
    private func touchUpInsideToSetPhotoView() {
        if isTemplateView {
            isTemplateView.toggle()
            underbarUIView.removeFromSuperview()
            setupUnderbarViewLayout()
            postThemePicerkView.removeFromSuperview()
            setupPostPhotoPickerViewLayout()
            postView.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
            postView.setSecondDotLayout()
        }
    }

    @objc
    private func touchUpInsideToConfirmPost() {
        Task {
            if !isBeingSaved {
                isBeingSaved = true
                setupActivityIndicatorLayout()
                guard let image = postView.postImageCollectionViewCell.imageView.image else {
                    let rollingPaperPostData = PostWithImageAndMessage(type: .imageAndMessage,
                                                                       id: "", timestamp: Date(),
                                                                       from: UserDefaults.standard.string(forKey: "uid") ?? "",
                                                                       isPublic: self.postView.isPublic,
                                                                       imageURL: nil,
                                                                       message: self.postView.postTextCollectionViewCell.textView.text,
                                                                       postTheme: self.postThemePicerkView.selectedThemeHex)

                    let rollingPaperPostAPI = RollingPaperPostAPI()
                    rollingPaperPostAPI.writePost(document: rollingPaperPostData,
                                                  imageUrl: nil,
                                                  groupId: self.groupId,
                                                  receiver: self.receiverUserId)
                    self.isBeingSaved = false
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true)
                    
                    return
                }
                FirebaseStorageManager.uploadImage(image: image, pathRoot: receiverUserId) { url in
                    guard let url = url else { return }
                    let absoluteUrl = url.absoluteString
                    let rollingPaperPostData = PostWithImageAndMessage(type: .imageAndMessage,
                                                                   id: "", timestamp: Date(),
                                                                   from: UserDefaults.standard.string(forKey: "uid") ?? "",
                                                                   isPublic: self.postView.isPublic,
                                                                   imageURL: absoluteUrl,
                                                                   message: self.postView.postTextCollectionViewCell.textView.text,
                                                                   postTheme: self.postThemePicerkView.selectedThemeHex)

                    let rollingPaperPostAPI = RollingPaperPostAPI()
                    rollingPaperPostAPI.writePost(document: rollingPaperPostData,
                                                  imageUrl: absoluteUrl,
                                                  groupId: self.groupId,
                                                  receiver: self.receiverUserId)
                    self.isBeingSaved = false
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    private func setupWholeLayout() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            dismissButton.widthAnchor.constraint(equalToConstant: 60),
            dismissButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 56),
            completeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        setupPostLayout()
        
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 14),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        buttonStackView.addArrangedSubview(templateButton)
        templateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            templateButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            templateButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
            templateButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            templateButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 2)
        ])
        
        buttonStackView.addArrangedSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            photoButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor),
            photoButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            photoButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 2)
        ])
        
        setupUnderbarViewLayout()
        
        setupPostThemePickerViewLayout()
    }
    
    private func setupPostLayout() {
        view.addSubview(postView)
        postView.writerNickname = writerNickname
        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 10),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            postView.heightAnchor.constraint(equalToConstant: PostView.LayoutValue.postSize.width + 45),
        ])
    }
    
    func setupUnderbarViewLayout() {
        view.addSubview(underbarUIView)
        underbarUIView.translatesAutoresizingMaskIntoConstraints = false
        if isTemplateView {
            NSLayoutConstraint.activate([
                underbarUIView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10),
                underbarUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                underbarUIView.heightAnchor.constraint(equalToConstant: 2),
                underbarUIView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 2)
            ])
        } else {
            NSLayoutConstraint.activate([
                underbarUIView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10),
                underbarUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                underbarUIView.heightAnchor.constraint(equalToConstant: 2),
                underbarUIView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 2)
            ])
        }
    }
    
    func setupPostThemePickerViewLayout() {
        view.addSubview(postThemePicerkView)
        postThemePicerkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postThemePicerkView.topAnchor.constraint(equalTo: underbarUIView.bottomAnchor, constant: 16),
            postThemePicerkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postThemePicerkView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postThemePicerkView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupPostPhotoPickerViewLayout() {
        view.addSubview(postPhotoPickerView)
        postPhotoPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postPhotoPickerView.topAnchor.constraint(equalTo: underbarUIView.bottomAnchor, constant: 16),
            postPhotoPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postPhotoPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postPhotoPickerView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 20 * 2 - 8) / 2)
        ])
    }
    
    private func setupActivityIndicatorLayout() {
        view.addSubview(activityIndicatorBackgroundView)
        activityIndicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicatorBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(activityIndicatorLabel)
        activityIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            activityIndicatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
}

extension WriteRollingPaperViewController: WriteRollingPaperViewDelegate {
    func presentImagePickerViewController(imageViewController: UIImagePickerController) {
        present(imageViewController, animated: true, completion: nil)
    }
    
    func presentAlert(alertViewController: UIAlertController) {
        present(alertViewController, animated: true, completion: nil)
    }
    
    func activeConfirmButton() {
        completeButton.backgroundColor = .systemBlack
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.isEnabled = true
    }

    func inactiveConfirmButton() {
        completeButton.backgroundColor = .inactiveBgGray
        completeButton.setTitleColor(.inactiveTextGray, for: .normal)
        completeButton.isEnabled = false
    }
}

