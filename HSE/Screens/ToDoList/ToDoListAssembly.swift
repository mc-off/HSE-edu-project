

enum ToDoListAssembly {
    static func assembly() -> ToDoListVC {
        let apiFetcher: ApiManagerWeatherProtocol = ApiManagerWeather()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter()
        let interactor = ToDoListInteractor(presenter, apiFetcher: apiFetcher)
        let viewController = ToDoListVC(interactor, router: router)
        
        presenter.view = viewController
        router.view = viewController
        return viewController
    }
}
