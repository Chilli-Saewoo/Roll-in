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
    }
}
