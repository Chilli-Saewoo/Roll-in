//
//  GroupDetailViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/14.
//

import UIKit
import VerticalCardSwiper

final class GroupDetailViewController: UIViewController {
    var group: Group?
    private var cardSwiper: VerticalCardSwiper!
    private let groupMessageLabel = UILabel()
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let ingroupCodeCopyLabel = UILabel()
    private let ingroupCodeCopyButton = UIButton()
    private let codeCopyToastView = UILabel()
    private var isFirstLoading = true
    
    var usersList: [(String, String)] {
        guard let group = group else { return [] }
        let list = group.participants.sorted {
            if $0.key == UserDefaults.standard.string(forKey: "uid")  {
                return false
            }
            if $1.key == UserDefaults.standard.string(forKey: "uid")  {
                return true
            }
            if isStartedWithKorean(str: $0.value.lowercased()) && isStartedWithEnglish(str: $1.value.lowercased()) {
                return false
            } else if isStartedWithEnglish(str: $0.value.lowercased()) && isStartedWithKorean(str: $1.value.lowercased()) {
                return true
            }
            return $0.value.lowercased() > $1.value.lowercased()
        }
        return list
    }
    
    private func isStartedWithKorean(str: String) -> Bool {
        if str >= "가" && str <= "힣" {
            return true
        }
        return false
    }
    
    private func isStartedWithEnglish(str: String) -> Bool {
        if (str >= "a" && str <= "z") || (str >= "A" && str <= "Z") {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGroupMessageLabel()
        setIngroupCodeCopyButton()
        setIngroupCodeCopyLabel()
        setIngroupCopyButtonAction()
        setNavigationBarBackButton()
        setCardSwiper()
        view.addSubview(cardSwiper)
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.register(CardSwiperCell.self, forCellWithReuseIdentifier: "CardCell")
        cardSwiper.layer.opacity = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstLoading {
            let _ = cardSwiper.scrollToCard(at: (group?.participants.count ?? 1) - 1, animated: false)
            cardSwiper.layer.opacity = 1.0
            isFirstLoading = false
        }
    }
    
    private func setIngroupCopyButtonAction() {
        ingroupCodeCopyButton.addTarget(self, action: #selector(ingroupCopyButtonPressed), for: .touchUpInside)
    }
    
    @objc func ingroupCopyButtonPressed(_ sender: UIButton) {
        guard let code = group?.code else { return }
        UIPasteboard.general.string = code
        setToastView()
        showToastView()
    }
}

extension GroupDetailViewController: VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController ?? UIViewController()
        let vc = secondViewController as? PostViewController
        vc?.receiverNickname = usersList[index].1
        vc?.receiverUserId = usersList[index].0
        vc?.groupId = group?.groupId
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: index) as? CardSwiperCell {
            cardCell.setCell(index: index, name: usersList[index].1, userId: usersList[index].0)
            return cardCell
        }
        return CardCell()
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return group?.participants.count ?? 0
    }
}

private extension GroupDetailViewController {
    func setCardSwiper() {
        cardSwiper = VerticalCardSwiper(frame: CGRect(x: 0.0, y: screenHeight * 0.2, width: screenWidth, height: screenHeight * 0.8))
        cardSwiper.isSideSwipingEnabled = false
        cardSwiper.topInset = 54
        cardSwiper.stackedCardsCount = 4
        cardSwiper.cardSpacing = 14
        cardSwiper.isStackOnBottom = false
        cardSwiper.visibleNextCardHeight = 50
        cardSwiper.firstItemTransform = 0.04
    }
}

private extension GroupDetailViewController {
    func setGroupMessageLabel() {
        view.addSubview(groupMessageLabel)
        groupMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            groupMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 117),
        ])
        groupMessageLabel.font = .systemFont(ofSize: 26, weight: .medium)
        groupMessageLabel.text = "\(group?.groupName ?? "")"
    }
    
    func setNavigationBarBackButton() {
        guard let groupName = group?.groupName else { return }
        let backBarButtonItem = UIBarButtonItem(title: "\(groupName)", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

private extension GroupDetailViewController {
    func setIngroupCodeCopyButton() {
        view.addSubview(ingroupCodeCopyButton)
        ingroupCodeCopyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ingroupCodeCopyButton.centerYAnchor.constraint(equalTo: groupMessageLabel.centerYAnchor),
            ingroupCodeCopyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ingroupCodeCopyButton.widthAnchor.constraint(equalToConstant: 77),
            ingroupCodeCopyButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        ingroupCodeCopyButton.backgroundColor = .systemBlack
        ingroupCodeCopyButton.layer.cornerRadius = 4.0
    }
    
    func setIngroupCodeCopyLabel() {
        ingroupCodeCopyButton.addSubview(ingroupCodeCopyLabel)
        ingroupCodeCopyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ingroupCodeCopyLabel.centerXAnchor.constraint(equalTo: ingroupCodeCopyButton.centerXAnchor),
            ingroupCodeCopyLabel.centerYAnchor.constraint(equalTo: ingroupCodeCopyButton.centerYAnchor),
            ingroupCodeCopyLabel.widthAnchor.constraint(equalTo: ingroupCodeCopyButton.widthAnchor),
            ingroupCodeCopyLabel.heightAnchor.constraint(equalTo: ingroupCodeCopyButton.heightAnchor),
        ])
        ingroupCodeCopyLabel.isUserInteractionEnabled = false
        let imageAttachment = NSTextAttachment()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        imageAttachment.image = UIImage(systemName: "square.on.square", withConfiguration: imageConfig)?.withTintColor(.white)
        let buttonTitle = NSMutableAttributedString(attachment: imageAttachment)
        buttonTitle.append(NSMutableAttributedString(string: " 코드 복사"))
        ingroupCodeCopyLabel.attributedText = buttonTitle
        ingroupCodeCopyLabel.font = .systemFont(ofSize: 12, weight: .medium)
        ingroupCodeCopyLabel.textColor = .white
        ingroupCodeCopyLabel.textAlignment = .center
    }
    
    func setToastView() {
        view.addSubview(codeCopyToastView)
        codeCopyToastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeCopyToastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 41),
            codeCopyToastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeCopyToastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            codeCopyToastView.heightAnchor.constraint(equalToConstant: 56)
        ])
        guard let groupName = group?.groupName else { return }
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white)
        let toastMessage = NSMutableAttributedString(attachment: imageAttachment)
        toastMessage.append(NSMutableAttributedString(string: " \(groupName) 그룹 코드가 복사되었어요"))
        codeCopyToastView.attributedText = toastMessage
        codeCopyToastView.font = .systemFont(ofSize: 16, weight: .medium)
        codeCopyToastView.textColor = .white
        codeCopyToastView.textAlignment = .center
        codeCopyToastView.backgroundColor = .black.withAlphaComponent(0.7)
        codeCopyToastView.layer.cornerRadius = 16
        codeCopyToastView.clipsToBounds  =  true
    }
    
    func showToastView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.codeCopyToastView.transform = CGAffineTransform(translationX: 0, y: -97)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseOut, animations: {
                self.codeCopyToastView.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { _ in
                self.codeCopyToastView.removeFromSuperview()
            })
        })
    }
}
