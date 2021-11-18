//
//  SettingsVC.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 15.11.2021.
//

import UIKit

final class SettingsVC: UIViewController {
    
    private static var cellID = "CellID"
    
    private lazy var models: [SectionData] = {
        let section1 = SectionData(
            title: "2",
            data: "Push-up notifications",
            "Appearance Dark/Light"
        )
        let section2 = SectionData(
            title: "",
            data: "Log out"
        )
        

        return [section1, section2]
    }()
    
    private var sectionCount: [Int]!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: SettingsVC.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
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
        cell.textLabel?.text = models[indexPath.section][indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].numberOfItems
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
}
