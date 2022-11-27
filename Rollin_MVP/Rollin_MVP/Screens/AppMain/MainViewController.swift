//
//  MainViewController.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/08.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MainViewController: UIViewController {
    private let db = Firestore.firestore()
    private let mainTitleLabel = UILabel()
    private let settingButton = UIButton()
    private lazy var bottomGradientView = UIView()
    private let addGroupCard = AddGroupButtonBackgroundView()
    private var groupsCollectionView: UICollectionView!
    private var groups: [Group] = [] {
        didSet {
            groupsCollectionView.reloadData()
        }
    }
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.color = .systemBlack
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainTitleLabel()
        setSettingButton()
        setAddGroupCard()
        setNavigationBarBackButton()
        addGroupCard.delegate = self
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
        setBottomGradientLayout()
        view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        fetchGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

private extension MainViewController {
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let width: CGFloat = UIScreen.main.bounds.width - 40
        let height: CGFloat = 100
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        groupsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(groupsCollectionView)
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupsCollectionView.topAnchor.constraint(equalTo: addGroupCard.bottomAnchor, constant: 12),
            groupsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groupsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            groupsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        groupsCollectionView.backgroundColor =  .clear
    }
    
        func registerCollectionView() {
            groupsCollectionView.register(MainGroupCardViewCell.classForCoder(), forCellWithReuseIdentifier: "mainGroupCard")
        }
            
        func collectionViewDelegate() {
            groupsCollectionView.delegate = self
            groupsCollectionView.dataSource = self
        }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetail") as? GroupDetailViewController ?? UIViewController()
        (secondViewController as? GroupDetailViewController)?.group = groups[indexPath.row]
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupsCollectionView.dequeueReusableCell(withReuseIdentifier: "mainGroupCard", for: indexPath) as? MainGroupCardViewCell ?? MainGroupCardViewCell()
        cell.setCardView(info: groups[indexPath.row])
        return cell
    }
}

extension MainViewController: AddGroupButtonBackgroundDelegate {
    func participateActionSelected() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchGroupWithCode") as? SearchGroupWithCodeViewController ?? UIViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func createActionSelected() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SetGroupNameWhileCreatingGroup") as? SetGroupNameWhileCreatingGroupViewController ?? UIViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func showActionSheet(sheet: UIAlertController) {
        present(sheet, animated: true, completion: nil)
    }
}

private extension MainViewController {
    func fetchGroups() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            let docRef = db.collection("userGroups").document(uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let groupIds = document.data().map{
                        $0["division"] as? [String] ?? []
                    } ?? [String]()
                    var newGroups: [Group] = []
                    for idx in 0..<groupIds.count {
                        let groupsRef = self.db.collection("groups").document(groupIds[idx])
                        groupsRef.getDocument(as: Group.self) { result in
                            switch result {
                                case .success(let group):
                                self.db.collection("groupUsers").document(groupIds[idx]).collection("participants").getDocuments() { querySnapshot, error in
                                    if let err = error {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        group.participants = []
                                        for document in querySnapshot?.documents ?? [] {
                                            group.participants.append((document.documentID, document.data()["groupNickname"] as? String ?? ""))
                                            if document.documentID == UserDefaults.standard.string(forKey: "uid") ?? "" {
                                                group.groupNickname = document.data()["groupNickname"] as? String ?? ""
                                            }
                                        }
                                        group.groupId = groupIds[idx]
                                        newGroups.append(group)
                                        newGroups.sort(by: >)
                                        if newGroups.count == groupIds.count {
                                            self.groups = newGroups
                                            self.activityIndicator.stopAnimating()
                                            self.view.isUserInteractionEnabled = true
                                        }
                                    }
                                }
                                case .failure(let error):
                                print("Error decoding group: \(error)")
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

private extension MainViewController {
    func setMainTitleLabel() {
        view.addSubview(mainTitleLabel)
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
        ])
        mainTitleLabel.font = .systemFont(ofSize: 26, weight: .medium)
        mainTitleLabel.text = "\(UserDefaults.standard.string(forKey: "nickname") ?? "")의 롤인 그룹"
    }
    
    
    func setAddGroupCard() {
        view.addSubview(addGroupCard)
        addGroupCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addGroupCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addGroupCard.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 40),
            addGroupCard.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setBottomGradientLayout() {
        view.addSubview(bottomGradientView)
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        bottomGradientView.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.height * 0.9),
                                          size: CGSize(width: view.frame.width, height: view.frame.height * 0.1))
        bottomGradientView.setGradient(color1: .init(red: 1, green: 1, blue: 1, alpha: 0), color2: .white)
    }
    
    func setSettingButton() {
        view.addSubview(settingButton)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingButton.centerYAnchor.constraint(equalTo: mainTitleLabel.centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        settingButton.setImage(UIImage(systemName: "gear", withConfiguration: imageConfig), for: .normal)
        settingButton.tintColor = .systemBlack
    }
    
    func setNavigationBarBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "롤인 그룹", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

extension UIView {
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 0.65]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
