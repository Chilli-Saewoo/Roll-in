//
//  DetailRollingPaperViewController.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/11/11.
//


import UIKit
import MessageUI

final class DetailRollingPaperViewController: UIViewController {
    
    var post: PostWithImageAndMessage?
    var image: UIImage?
    
    private enum LayoutValue {
        static let postSize = CGSize(width: UIScreen.main.bounds.width - 76, height: (UIScreen.main.bounds.height / 2) - 114)
        static let postSpacing = 38.0
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.postSize.width) / 2.0
        }
        static var collectionViewContentInset = UIEdgeInsets(top: 5, left: insetX, bottom: 0, right: insetX)
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "상세보기"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let reportPostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "light.beacon.max.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let pageControllerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let pageControllerFirstDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let pageControllerSecondDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewFlowLayout()
        setCollectionView()
        setPostLayout()
        setButton()
    }
}

extension DetailRollingPaperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let post = post else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPostLabelCollectionViewCell.className, for: indexPath) as! DetailPostLabelCollectionViewCell
            let textColor = getTextColor(backgroundColorString: post.postTheme)
            cell.message.text = post.message
            cell.message.textColor = textColor
            cell.detailPostView.backgroundColor = hexStringToUIColor(hex: post.postTheme)
            cell.from.text = "From. \(post.from)"
            cell.from.textColor = textColor
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPostImageCollectionViewCell.className, for: indexPath) as! DetailPostImageCollectionViewCell
            cell.imageView.image = image ?? UIImage()
            return cell
        }
    }
    
    func getTextColor(backgroundColorString: String) -> UIColor {
        switch backgroundColorString  {
        case "FFFCDD":
            return hexStringToUIColor(hex: "9E6003")
        case "FEE0EA":
            return hexStringToUIColor(hex: "D61951")
        case "EBDDFF":
            return hexStringToUIColor(hex: "4D2980")
        case "DDEBFF":
            return hexStringToUIColor(hex: "4069CE")
        case "C8F6D5":
            return hexStringToUIColor(hex: "15843B")
        default:
            return hexStringToUIColor(hex: "9E6003")
        }
    }
    
    
    // https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}

extension DetailRollingPaperViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = LayoutValue.postSize.width + LayoutValue.postSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        if index == 0.0 {
            pageControllerFirstDotView.backgroundColor = .black
            pageControllerSecondDotView.backgroundColor = .lightGray
            pageControllerFirstDotView.removeFromSuperview()
            pageControllerSecondDotView.removeFromSuperview()
            pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
            pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        } else if index == 1.0 {
            pageControllerFirstDotView.backgroundColor = .lightGray
            pageControllerSecondDotView.backgroundColor = .black
            pageControllerFirstDotView.removeFromSuperview()
            pageControllerSecondDotView.removeFromSuperview()
            pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
            pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        }
    }
}

private extension DetailRollingPaperViewController {
    func setCollectionViewFlowLayout() {
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize = LayoutValue.postSize
        collectionViewFlowLayout.minimumLineSpacing = LayoutValue.postSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = 0
    }
    
    func setCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(DetailPostLabelCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostLabelCollectionViewCell.className)
        collectionView.register(DetailPostImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostImageCollectionViewCell.className)
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = LayoutValue.collectionViewContentInset
        collectionView.decelerationRate = .fast
    }
    
    func setPostLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.dismissButton)
        NSLayoutConstraint.activate([
            self.dismissButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 40),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        reportPostButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.reportPostButton)
        NSLayoutConstraint.activate([
            self.reportPostButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.reportPostButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.reportPostButton.heightAnchor.constraint(equalToConstant: 40),
            self.reportPostButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: LayoutValue.postSize.height),
            self.collectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 22),
        ])
        
        pageControllerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControllerStackView)
        NSLayoutConstraint.activate([
            pageControllerStackView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 15),
            pageControllerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageControllerStackView.heightAnchor.constraint(equalToConstant: 8),
            pageControllerStackView.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        pageControllerStackView.addArrangedSubview(pageControllerFirstDotView)
        pageControllerFirstDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerFirstDotView.topAnchor.constraint(equalTo: self.pageControllerStackView.topAnchor),
            pageControllerFirstDotView.leadingAnchor.constraint(equalTo: self.pageControllerStackView.leadingAnchor),
            pageControllerFirstDotView.bottomAnchor.constraint(equalTo: self.pageControllerStackView.bottomAnchor),
            pageControllerFirstDotView.heightAnchor.constraint(equalToConstant: 8),
            pageControllerFirstDotView.widthAnchor.constraint(equalToConstant: 8),
        ])
        
        pageControllerStackView.addArrangedSubview(pageControllerSecondDotView)
        pageControllerSecondDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControllerSecondDotView.topAnchor.constraint(equalTo: self.pageControllerStackView.topAnchor),
            pageControllerSecondDotView.trailingAnchor.constraint(equalTo: self.pageControllerStackView.trailingAnchor),
            pageControllerSecondDotView.bottomAnchor.constraint(equalTo: self.pageControllerStackView.bottomAnchor),
            pageControllerSecondDotView.heightAnchor.constraint(equalToConstant: 8),
            pageControllerSecondDotView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func setButton() {
        dismissButton.addTarget(self, action: #selector(touchUpInsideToDismiss), for: .touchUpInside)
        reportPostButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
    }
    
    func touchUpInsideDeclarePage() {
        if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                guard let postRollingPaperModel = postRollingPaperModel else { return }
                composeViewController.mailComposeDelegate = self
                let date = Date()
                let bodyString = """
                                 
                                 -------------------
                                 
                                 
                                 - 신고자 닉네임 : \(postRollingPaperModel.from)
                                 - 신고 메시지 내용 :
                                 \(postRollingPaperModel.commentString)
                                 - 신고 날짜: \(date.toString_koreaTime())
                                 
                                 -------------------
                                 
                                 신고 내용을 작성해주세요.
                                 
                                 신고 사유:
                                 
                                 """
                
                composeViewController.setToRecipients(["chillijo2022@gmail.com"])
                composeViewController.setSubject("[신고 관련 문의]")
                composeViewController.setMessageBody(bodyString, isHTML: false)
                
                self.present(composeViewController, animated: true, completion: nil)
            } else {
                print("메일 보내기 실패")
                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                    // 앱스토어로 이동하기(Mail)
                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                
                sendMailErrorAlert.addAction(goAppStoreAction)
                sendMailErrorAlert.addAction(cancleAction)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
    }
    
    @objc
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "해당 포스트를 신고하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        let reportSheet = UIAlertAction(title: "신고 하기", style: .default) { action in
            self.touchUpInsideDeclarePage()
        }
        let cancelSheet = UIAlertAction(title: "취소", style: .cancel) { action in
        }
        actionSheet.addAction(reportSheet)
        actionSheet.addAction(cancelSheet)
        
        reportSheet.setValue(UIColor.red, forKey: "titleTextColor")
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc
    func touchUpInsideToDismiss() {
        self.dismiss(animated: true)
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate
extension DetailRollingPaperViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
