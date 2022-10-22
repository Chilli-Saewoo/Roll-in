//
//  RollingpaperViewController.swift
//  RollIn
//
//  Created by 한택환 on 2022/10/22.
//

import UIKit

final class RollingpaperViewController: UIViewController {
    private var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRollingpaperView()
    }
}

private extension RollingpaperViewController {
    func setRollingpaperView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RollingpaperTableViewCell.classForCoder(), forCellReuseIdentifier: "RollingpaperCell")
        self.view.addSubview(tableView)
        setRollingpaperTableViewLayout()
    }
}

extension RollingpaperViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RollingpaperCell") as? RollingpaperTableViewCell ?? UITableViewCell()
        
        return cell
    }
}

extension RollingpaperViewController: UITableViewDelegate {
}

private extension RollingpaperViewController {
    func setRollingpaperTableViewLayout() {
        print("set")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
