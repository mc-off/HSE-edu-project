//
//  SettingsVC.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 15.11.2021.
//

import UIKit

final class SettingsVC: UIViewController {
    
    private static var cellID = "CellID"
    
    private struct Model {
        let name: String
        let segment: Int
    }
    
    private let models: [Model] = [
        .init(name: "Push-up notifications", segment: 0),
        .init(name: "Appearance Dark/Light", segment: 0),
        .init(name: "Log out", segment: 1)
    ]
    
    private var sectionCount: [Int]!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: SettingsVC.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionCount = [Int](repeating: 0, count: models.count)
        for item in models {
            sectionCount[item.segment] += 1
        }

        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
    }
    
}

// MARK: - UITableView Delegate&DataSource

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsVC.cellID, for: indexPath) as UITableViewCell
        cell.textLabel?.text = models[indexPath.row].name
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// Ячейка которая соотвествует протоколу для ее создания и наследования
// Generic table view который принимает Cell протокол для ячейки, Model данных
// Generic table view data source который в себе содержит Model
// var models: [Model]
