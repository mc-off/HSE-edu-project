//
//  TableViewController.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 18.11.2021.
//

import UIKit

class TableViewController<Model, Cell: UITableViewCell>: UITableViewController {
    
    var items: [Model]
    var configure: (Cell, Model) -> Void
    var didTap: (Model) -> Void
    
    init(
        _ items: [Model],
        configure: @escaping(Cell, Model) -> Void,
        didTap: @escaping(Model) -> Void
    ) {
        self.items = items
        self.configure = configure
        self.didTap = didTap
        super.init(style: .plain)
        self.tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell
        else {
            return UITableViewCell()
        }
        configure(cell, items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTap(items[indexPath.row])
    }
}
