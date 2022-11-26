//
//  SetThemeViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/10.
//

import UIKit

final class SetThemeViewController: GroupBaseViewController {
    var creatingGroupInfo: CreatingGroupInfo?
    //private var setBackgroundPaperTextLabel = UILabel()
    private var backgroundPapersCollectionView: UICollectionView!
    private let screenWidth = UIScreen.main.bounds.width
    private let backgroundColorDatas = BackgroundColorSet.datas
    private let iconDatas = IconsSet.datas
    private var iconTextSettingLabel = UILabel()
    private var iconsCollectionView: UICollectionView!
    private var nextButton = UIButton()
    private var selectedBackgroundColor: String? = nil {
        didSet {
            if selectedBackgroundColor != nil && selectedIcon != nil {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .systemBlack
                nextButton.setTitle("다음", for: .normal)
                nextButton.setTitleColor(.white, for: .normal)
            }
        }
    }
    private var selectedIcon: String? = nil {
        didSet {
            if selectedBackgroundColor != nil && selectedIcon != nil {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .systemBlack
                nextButton.setTitle("다음", for: .normal)
                nextButton.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setViewTitle(title: "그룹 배경지 선택")
        configureCollectionView()
        registerBackgroundCollectionView()
        backgroundCollectionViewDelegate()
        setIconTextSettingLabel()
        configureIconCollectionView()
        registerIconCollectionView()
        iconCollectionViewDelegate()
        setNextButton()
        setNextButtonAction()
        setNavigationBarBackButton()
    }
    
    private func setNextButtonAction() {
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        
        creatingGroupInfo?.backgroundColor = selectedBackgroundColor
        creatingGroupInfo?.icon = selectedIcon
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmGroup") as? ConfirmGroupViewController ?? UIViewController()
        (secondViewController as? ConfirmGroupViewController)?.creatingGroupInfo = creatingGroupInfo
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

private extension SetThemeViewController {
    func setNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = 4.0
        nextButton.setTitle("다음", for: .disabled)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitleColor(.inactiveTextGray, for: .disabled)
        nextButton.backgroundColor = .inactiveBgGray
    }
    
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "그룹 테마 선택", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

private extension SetThemeViewController {
    func setIconTextSettingLabel() {
        view.addSubview(iconTextSettingLabel)
        iconTextSettingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconTextSettingLabel.topAnchor.constraint(equalTo: backgroundPapersCollectionView.bottomAnchor, constant: 38),
            iconTextSettingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
        ])
        iconTextSettingLabel.text = "그룹 아이콘 선택"
        iconTextSettingLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    func configureIconCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 7
        let width = (screenWidth - 70) / 5
        let height = width * 1.36
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        iconsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        iconsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        iconsCollectionView.backgroundColor = .clear
        view.addSubview(iconsCollectionView)
        NSLayoutConstraint.activate([
            iconsCollectionView.topAnchor.constraint(equalTo: iconTextSettingLabel.bottomAnchor, constant: 20),
            iconsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            iconsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            iconsCollectionView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func registerIconCollectionView() {
        iconsCollectionView.register(SelectIconCell.classForCoder(), forCellWithReuseIdentifier: "cellIdentifierB")
    }
    
    func iconCollectionViewDelegate() {
        iconsCollectionView.delegate = self
        iconsCollectionView.dataSource = self
    }
    
}

private extension SetThemeViewController {
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 7
        let width = (screenWidth - 70) / 5
        let height = width * 1.36
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        backgroundPapersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        backgroundPapersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        backgroundPapersCollectionView.backgroundColor = .clear
        view.addSubview(backgroundPapersCollectionView)
        NSLayoutConstraint.activate([
            backgroundPapersCollectionView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 20),
            backgroundPapersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            backgroundPapersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            backgroundPapersCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func registerBackgroundCollectionView() {
        backgroundPapersCollectionView.register(SelectBackgroundColorCell.classForCoder(), forCellWithReuseIdentifier: "cellIdentifierA")
    }
    
    func backgroundCollectionViewDelegate() {
        backgroundPapersCollectionView.delegate = self
        backgroundPapersCollectionView.dataSource = self
    }
}

extension SetThemeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == backgroundPapersCollectionView {
            for idx in 0 ..< backgroundColorDatas.count {
                let aIndexPath = IndexPath(row: idx, section: 0)
                if indexPath.row == aIndexPath.row {
                    let cell = backgroundPapersCollectionView.cellForItem(at: aIndexPath) as? SelectBackgroundColorCell
                    if cell?.isActivate == false {
                        cell?.activateCell()
                        selectedBackgroundColor = backgroundColorDatas[aIndexPath.row].backgroundColorString
                    } else {
                        cell?.inactivateCell()
                        selectedBackgroundColor = nil
                    }
                    cell?.isActivate.toggle()
                    
                } else {
                    let cell = backgroundPapersCollectionView.cellForItem(at: aIndexPath) as? SelectBackgroundColorCell
                    cell?.inactivateCell()
                    cell?.isActivate = false
                }
            }
        } else {
            for idx in 0 ..< iconDatas.count {
                let aIndexPath = IndexPath(row: idx, section: 0)
                if indexPath.row == aIndexPath.row {
                    let cell = iconsCollectionView.cellForItem(at: aIndexPath) as? SelectIconCell
                    if cell?.isActivate == false {
                        cell?.activateCell()
                        selectedIcon = iconDatas[aIndexPath.row].imageName
                    } else {
                        cell?.inactivateCell()
                        selectedIcon = nil
                    }
                    cell?.isActivate.toggle()
                    
                } else {
                    let cell = iconsCollectionView.cellForItem(at: aIndexPath) as? SelectIconCell
                    cell?.inactivateCell()
                    cell?.isActivate = false
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == backgroundPapersCollectionView {
            return backgroundColorDatas.count
        } else {
            return iconDatas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == backgroundPapersCollectionView {
            let cell = backgroundPapersCollectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifierA", for: indexPath) as? SelectBackgroundColorCell ?? SelectBackgroundColorCell()
            cell.setCellContents(data: backgroundColorDatas[indexPath.row])
            return cell
        } else {
            let cell = iconsCollectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifierB", for: indexPath) as? SelectIconCell ?? SelectIconCell()
            cell.setCellContents(data: iconDatas[indexPath.row])
            return cell
        }
    }
}
