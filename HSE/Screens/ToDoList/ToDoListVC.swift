//
//  ToDoListVC.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//

import UIKit

/*
 MVC - Model View Controller
 
 Clean Swift (VIPER) -
 
 View (View Controller)- отобржание --->
 Interactor - взаимодействие ---->
 Presenter - отображение данных (ошибок) с севера ------> VIEW
 
 Router - навигация (передача данных в другие VC) <------ VIEW
 Model(Entity) - модель данных , контанты, запросы
 */

final class ToDoListVC: UIViewController {
    
    private let interactor: ToDoListBusinessLogic
    private let router: ToDoListRoutingLogic
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(ToDoListCell.self, forCellReuseIdentifier: ToDoListCell.id)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        table.refreshControl = refreshControl
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var flyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Variables
    
    private var items: [ToDoListItem] = []
    
    // MARK: - Lifecycle
    
    init(
        _ interactor: ToDoListBusinessLogic,
        router: ToDoListRoutingLogic
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.fetchItems(.init(nil, .all))
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.rightBarButtonItems = setupNavButtons()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "To Do List Items"
//        if let window = UIWindow.key {
//            window.addSubview(flyButton)
//            setupFlyButton()
//        }
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let window = UIApplication.shared.keyWindow,
//           flyButton.isDescendant(of: view) {
//            flyButton.removeFromSuperview()
//        }
//    }
    
    @objc
    private func refreshData() {
        interactor.fetchItems(.init(nil, .all))
    }
    
    @objc
    private func goToSettings() {
        router.routeToSettings()
    }
    
    @objc
    private func plusButtonTapped() {
        router.routeToAddItem { [weak self] item in
            self?.interactor.fetchItems(.init(item, .add))
        }
    }
    
    private func setupNavButtons() -> [UIBarButtonItem] {
        let plusButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(plusButtonTapped))
        let settings = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(goToSettings)
        )
        return [settings, plusButton]
    }
}

// MARK: - Display Logic

extension ToDoListVC: ToDoListDisplayLogic {
    func displayUpdateItem(_ viewModel: ToDoListModels.UpdateItems.ViewModel) {
        
    }
    
    func displayCells(_ viewModel: ToDoListModels.FetchItems.ViewModel) {
        tableView.refreshControl?.endRefreshing()
        items = viewModel.items
        tableView.reloadData()
    }
    
    func displayError(_ viewModel: ToDoListModels.Error.ViewModel) {
        
    }
}

// MARK: - UITableView Delegate&DataSource

extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListCell.id, for: indexPath) as? ToDoListCell else {
            return UITableViewCell()
        }
        cell.model = items[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
}

// MARK: - Setup UI components

private extension ToDoListVC {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupFlyButton() {
        NSLayoutConstraint.activate([
            flyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            flyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            flyButton.widthAnchor.constraint(equalToConstant: 40),
            flyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
