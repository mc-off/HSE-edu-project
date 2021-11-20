//
//  ToDoListVC.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//

import UIKit

final class ToDoListVC: TableViewController<ToDoListItem,ToDoListCell> {
    
    private let interactor: ToDoListBusinessLogic
    private let router: ToDoListRoutingLogic
    
    // MARK: - UI Components

    private lazy var searchController: UISearchController = {
        let vc = UISearchController()
        return vc
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
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
    
    // MARK: - Lifecycle
    
    init(
        _ interactor: ToDoListBusinessLogic,
        router: ToDoListRoutingLogic
    ) {
        self.interactor = interactor
        self.router = router
        super.init([]) { cell, item in
            cell.model = item
        } didTap: { item in
            print(item.title)
        }

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
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        //searchController.searchBar.delegate = self
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
        router.routeToAddItem { [weak self] in
            self?.interactor.fetchItems(.init(nil, .all))
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
    
    private func filterItems(_ searchText: String) {
        filteredItems.removeAll()
        for item in items {
            if item.title.starts(with: searchText) {
                filteredItems.append(item)
            }
        }
        
        if !filteredItems.isEmpty {
            
        }
    }
}

// MARK: - Display Logic

extension ToDoListVC: ToDoListDisplayLogic {
    func displayLoad(_ viewModel: ToDoListModels.Load.ViewModel) {
        viewModel.show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func displayUpdateItem(_ viewModel: ToDoListModels.UpdateItems.ViewModel) {
        
    }
    
    func displayCells(_ viewModel: ToDoListModels.FetchItems.ViewModel) {
        tableView.refreshControl?.endRefreshing()
        items = viewModel.items
        tableView.reloadData()
    }
    
    func displayError(_ viewModel: ToDoListModels.Error.ViewModel) {
        alert(
            title: "Oups ERROR",
            desc: viewModel.title
        )
    }
}

extension ToDoListVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            interactor.fetchItems(.init(items[indexPath.row], .delete))
            items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
}

// MARK: - Search

extension ToDoListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        filterItems(text)
        
        tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        true
//    }
}

// MARK: - Setup UI components

private extension ToDoListVC {
    func setupTableView() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        tableView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
