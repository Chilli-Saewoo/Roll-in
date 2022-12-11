//
//  PostPhotoPickerView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/12/12.
//

import UIKit
import AVFoundation
import Photos

final class PostPhotoPickerView: UIView {
    
    private lazy var deletePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .bgGray
        button.tintColor = .systemBlack
        button.layer.cornerRadius = 4
        return button
    }()
    
    private let imagePickerViewController = UIImagePickerController()
//    private lazy var authorizationOfCameraAlert: () = makeAlert(title: "알림", message: "카메라 접근이 허용되어 있지 않습니다.")
//    private lazy var authorizationOfPhotoLibraryAlert: () = makeAlert(title: "알림", message: "라이브러리 접근이 허용되어 있지 않습니다.")
    private let addPhotoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    private let authorizationOfCameraAlert = UIAlertController(title: "알림", message: "롤인의 카메라 접근이 허용되어 있지 않습니다.", preferredStyle: .alert)
    private let authorizationOfPhotoLibraryAlert = UIAlertController(title: "알림", message: "롤인의 앨범 접근이 허용되어 있지 않습니다.", preferredStyle: .alert)

    let postPhotoPickerItemWidth = (UIScreen.main.bounds.width - (7 * 3) - (16 * 2))/4
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = .bgGray
        button.tintColor = .systemBlack
        button.layer.cornerRadius = 4
        return button
    }()
    
    weak var delegate: WriteRollingPaperViewDelegate?
    
    weak var postViewDelegate: PostViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setButton()
        setupImagePickerView()
        setPhotoAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton() {
        deletePhotoButton.addTarget(self, action: #selector(touchUpInsideToDeletePhoto), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(touchUpInsideToAddPhoto), for: .touchUpInside)
    }
    
    @objc
    func touchUpInsideToDeletePhoto() {
        print("delete")
    }
    
    @objc
    func touchUpInsideToAddPhoto() {
        print("add")
        delegate?.presentAlert(alertViewController: addPhotoAlert)
    }
    
    func setupLayout(){
        addSubview(deletePhotoButton)
        deletePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deletePhotoButton.topAnchor.constraint(equalTo: topAnchor),
            deletePhotoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            deletePhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            deletePhotoButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4)
        ])
        
        addSubview(addPhotoButton)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalTo: topAnchor),
            addPhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addPhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addPhotoButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 4)
        ])
    }
    
    func setupImagePickerView() {
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
    }
    
    private func setPhotoAlert() {
        let choosePhotoFromAlbumAction = UIAlertAction(title: "앨범에서 선택", style: .default, handler: { [weak self] _ in self?.checkAlbumPermission()})
        let takePhotoAction = UIAlertAction(title: "사진 촬영", style: .default, handler: { [weak self] _ in
            self?.checkCameraPermission()
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        let moveToSettingAction = UIAlertAction(title: "설정", style: .default, handler: { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        })
        addPhotoAlert.addAction(choosePhotoFromAlbumAction)
        addPhotoAlert.addAction(takePhotoAction)
        addPhotoAlert.addAction(cancelAction)
        authorizationOfCameraAlert.addAction(cancelAction)
        authorizationOfCameraAlert.addAction(moveToSettingAction)
        authorizationOfPhotoLibraryAlert.addAction(cancelAction)
        authorizationOfPhotoLibraryAlert.addAction(moveToSettingAction)
    }
    
    private func setImagePickerToPhotoLibrary() {
        imagePickerViewController.sourceType = .photoLibrary
        delegate?.presentImagePickerViewController(imageViewController: imagePickerViewController)
    }

    private func setImagePickerToCamera() {
        imagePickerViewController.sourceType = .camera
        delegate?.presentImagePickerViewController(imageViewController: imagePickerViewController)
    }

    private func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                DispatchQueue.main.async {
                    self.setImagePickerToCamera()
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.presentAlert(alertViewController: self.authorizationOfCameraAlert)
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
                    self.delegate?.presentAlert(alertViewController: self.authorizationOfPhotoLibraryAlert)
                }
            default:
                break
            }
        })
    }
}

//extension PostPhotoPickerView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        12
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostPhotoPickerViewCell.className, for: indexPath) as? PostPhotoPickerViewCell else { return UICollectionViewCell() }
//        if indexPath.row == 0 {
//            cell.imageView.removeFromSuperview()
//            cell.setupButtonLayout()
//            cell.button.setImage(UIImage(systemName: "xmark"), for: .normal)
//            cell.imageView.backgroundColor = .bgGray
//        } else if indexPath.row == 1 {
//            cell.imageView.removeFromSuperview()
//            cell.setupButtonLayout()
//            cell.button.setImage(UIImage(systemName: "photo"), for: .normal)
//            cell.imageView.backgroundColor = .bgGray
//        } else {
//            cell.imageView.backgroundColor = .bgGray
//        }
//
//        return cell
//    }
//
//
//}
    

//extension PostPhotoPickerView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? PostPhotoPickerViewCell else { return }
//        if indexPath.row == 1 {
//            cell.button.addTarget(self, action: #selector(touchUpInsideToSetPhoto), for: .touchUpInside)
//        } else {
//            print("hihihi")
//        }
//    }
//}

extension PostPhotoPickerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            postViewDelegate?.changePhoto(image: image)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
