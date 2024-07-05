//
//  HomeViewController.swift
//  Example-iOS
//
//  Created by 李文康 on 2024/7/5.
//  Copyright © 2024 Shanbay iOS. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureSubviews()
    }

    private lazy var _tableView: UITableView = {
        let result = UITableView()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.delegate = self
        result.dataSource = self
        result.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return result
    }()

    private lazy var _rows: [(String, (String) -> Void)] = [
        ("SYYAsyncLayer", { [weak self] in
            let scene = AsyncLayerViewController()
            scene.title = "\($0) Demo"
            self?.navigationController?.pushViewController(scene, animated: true)
        })
    ]
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = _rows[indexPath.row]
        row.1(row.0)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        _rows.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = _rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)).unsafelyUnwrapped
        cell.textLabel?.text = row.0
        return cell
    }
}

extension HomeViewController {
    private func _configureSubviews() {
        title = "SwiftyYYText Demo"
        view.addSubview(_tableView)
        NSLayoutConstraint.activate([
            _tableView.topAnchor.constraint(equalTo: view.topAnchor),
            _tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            _tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
