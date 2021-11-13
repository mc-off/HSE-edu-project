//
//  ToDoListInteractor.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//



final class ToDoListInteractor {
    
    private let presenter: ToDoListPresentationLogic
    
    private let manager: FirestoreManagerProtocol = FirestoreManager(.toDoList)
    
    init(_ presenter: ToDoListPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - Business Logic

extension ToDoListInteractor: ToDoListBusinessLogic {
    func fetchItems(_ request: ToDoListModels.FetchItems.Request) {
        switch request.action {
        case .all:
            manager.read { [weak self] result in
                switch result {
                case .success(let items):
                    self?.presenter.presentCells(.init(items: items))
                case .failure(let error):
                    self?.presenter.presentError(.init(title: error.localizedDescription))
                }
            }
        case .add, .edit:
            manager.addItem(
                request.item ?? ToDoListItem.prototype(),
                merge: (request.action == .edit)) { [weak self] result in
                    switch result {
                    case .success(_):
                        guard let item = request.item else { return }
                        self?.presenter.presentUpdate(.init(item: item))
                    case .failure(let error):
                        self?.presenter.presentError(.init(title: error.localizedDescription))
                    }
                }
        case .delete:
            manager.deleteItem(request.item ?? ToDoListItem.prototype()) { [weak self] result in
                switch result {
                case .success(_):
                    guard let item = request.item else { return }
                    self?.presenter.presentUpdate(.init(item: item))
                case .failure(let error):
                    self?.presenter.presentError(.init(title: error.localizedDescription))
                }
            }
        }
    }
}
