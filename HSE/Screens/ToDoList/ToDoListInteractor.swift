


final class ToDoListInteractor {
    
    private let presenter: ToDoListPresentationLogic
    
    private let manager: FirestoreManagerProtocol = FirestoreManager(.toDoList)
    
    private let apiFetcher: ApiManagerWeatherProtocol
    
    init(_ presenter: ToDoListPresentationLogic,
         apiFetcher: ApiManagerWeatherProtocol) {
        self.presenter = presenter
        self.apiFetcher = apiFetcher
    }
}

// MARK: - Business Logic

extension ToDoListInteractor: ToDoListBusinessLogic {
    
    func fetchWeather() {
        apiFetcher.getUsers(from: "") { (result: Result<Users, APIServiceError>) in
            switch result {
            case .success(let users):
                print(users.name)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchItems(_ request: ToDoListModels.FetchItems.Request) {
        presenter.presentLoad(.init(show: true))
        switch request.action {
        case .all:
            manager.read { [weak self] result in
                self?.presenter.presentLoad(.init(show: false))
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
                    self?.presenter.presentLoad(.init(show: false))
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
                self?.presenter.presentLoad(.init(show: false))
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
