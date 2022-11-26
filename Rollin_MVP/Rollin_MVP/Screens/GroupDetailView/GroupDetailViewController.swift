//
//  GroupDetailViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/14.
//

import UIKit
import VerticalCardSwiper

final class CardSwiperCell: CardCell {
    
    private let nameLabel = UILabel()
    
    public func setCell(index: Int, name: String) {
        let colors: [UIColor] = [.cardRed, .cardBlue, .cardPink, .cardGreen, .cardPurple, .cardYellow, .cardDeepBlue]
        self.backgroundColor = colors[index % colors.count]
        nameLabel.text = name
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        ])
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
}

final class GroupDetailViewController: UIViewController {
    var group: Group?
    private var cardSwiper: VerticalCardSwiper!
    private let groupMessageLabel = UILabel()
    private let participantsCountLabel = UILabel()
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let ingroupCodeCopyLabel = UILabel()
    private let ingroupCodeCopyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGroupMessageLabel()
        setIngroupCodeCopyButton()
        setIngroupCodeCopyLabel()
        setCopyButtonAction()
        setNavigationBarBackButton()
        cardSwiper = VerticalCardSwiper(frame: CGRect(x: 0.0, y: screenHeight * 0.2, width: screenWidth, height: screenHeight * 0.8))
        cardSwiper.isSideSwipingEnabled = false
        cardSwiper.topInset = 40
        cardSwiper.stackedCardsCount = 5
        cardSwiper.cardSpacing = 30
        cardSwiper.isStackOnBottom = false
        cardSwiper.visibleNextCardHeight = 50
        cardSwiper.firstItemTransform = 0.08
        view.addSubview(cardSwiper)
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.register(CardSwiperCell.self, forCellWithReuseIdentifier: "CardCell")
    }
    
    override func viewDidLayoutSubviews() {
        let _ = cardSwiper.scrollToCard(at: (group?.participants.count ?? 1) - 1, animated: false)
    }
    
    private func setCopyButtonAction() {
        ingroupCodeCopyButton.addTarget(self, action: #selector(ingroupCopyButtonPressed), for: .touchUpInside)
    }
    
    @objc func ingroupCopyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = group?.code ?? ""
        print(group?.code ?? "")
    }
}

extension GroupDetailViewController: VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController ?? UIViewController()
        let vc = secondViewController as? PostViewController
        vc?.groupNickname = group?.participants[index].1
        vc?.receiverUserId = group?.participants[index].0
        vc?.groupId = group?.groupId
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: index) as? CardSwiperCell {
            cardCell.setCell(index: index, name: group?.participants[index].1 ?? "error")
            return cardCell
        }
        return CardCell()
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return group?.participants.count ?? 0
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
    
    func setParticipantsCountLabel() {
        view.addSubview(participantsCountLabel)
        participantsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            participantsCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            participantsCountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
        ])
        participantsCountLabel.font = .systemFont(ofSize: 26, weight: .medium)
    }
    
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "\(group?.groupName ?? "")", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

private extension GroupDetailViewController {
    func setIngroupCodeCopyButton() {
        view.addSubview(ingroupCodeCopyButton)
        ingroupCodeCopyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ingroupCodeCopyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 129),
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
           imageAttachment.image = UIImage(systemName: "square.on.square")?.withTintColor(.white)
           let buttonTitle = NSMutableAttributedString(attachment: imageAttachment)
           buttonTitle.append(NSMutableAttributedString(string: " 코드 복사"))
           ingroupCodeCopyLabel.attributedText = buttonTitle
           ingroupCodeCopyLabel.font = .systemFont(ofSize: 12, weight: .semibold)
           ingroupCodeCopyLabel.textColor = .white
           ingroupCodeCopyLabel.textAlignment = .center
       }
    

}
