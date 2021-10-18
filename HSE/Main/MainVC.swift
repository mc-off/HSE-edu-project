//
//  File.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 18.10.2021.
//

struct Item {
    let title: String
    let description: String
}

import UIKit

final class MainVC: UIViewController {
    
    private var items: [Item] = []
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreManager.shared.getItems { [weak self] items in
            guard let self = self else { return }
            self.items = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let text = items[indexPath.row].title + ": \(items[indexPath.row].description)"
        cell.textLabel?.text = text
        return cell
    }
}

