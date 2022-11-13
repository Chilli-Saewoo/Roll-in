//
//  GroupDetailViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/14.
//

import UIKit
import VerticalCardSwiper

final class CardSwiperCell: CardCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let colors: [UIColor] = [.blue, .red, .yellow, .bgGreen, .bgPurple, .bgRed, .inactiveBgGray, .textYellow, .bgYellow, .bgBlue, .inactiveTextGray, .brown]
        self.backgroundColor = colors.randomElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class GroupDetailViewController: UIViewController {
    var group: Group?
    private var cardSwiper: VerticalCardSwiper!
    private let groupMessageLabel = UILabel()
    private let participantsCountLabel = UILabel()
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        setGroupMessageLabel()
        cardSwiper = VerticalCardSwiper(frame: CGRect(x: 0.0, y: screenHeight * 0.2, width: screenWidth, height: screenHeight * 0.8))
        cardSwiper.isSideSwipingEnabled = false
        cardSwiper.topInset = 40
        cardSwiper.stackedCardsCount = 5
        cardSwiper.cardSpacing = 30
        cardSwiper.isStackOnBottom = false
        cardSwiper.visibleNextCardHeight = 50
        cardSwiper.firstItemTransform = 0.05
        view.addSubview(cardSwiper)
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.register(CardSwiperCell.self, forCellWithReuseIdentifier: "CardCell")
    }
    
    override func viewDidLayoutSubviews() {
        let _ = cardSwiper.scrollToCard(at: 99, animated: false)
    }
}

extension GroupDetailViewController: VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
           if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: index) as? CardSwiperCell {
               return cardCell
           }
           return CardCell()
       }
       
       func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
           return 100//group?.participants.count ?? 0
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
        groupMessageLabel.text = "\(group?.groupName ?? "")의 롤링페이퍼"
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
    
}


