//
//  ToDoListAssembly.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//

enum ToDoListAssembly {
    static func assembly() -> ToDoListVC {
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter()
        let interactor = ToDoListInteractor(presenter)
        let viewController = ToDoListVC(interactor, router: router)
        
        presenter.view = viewController
        router.view = viewController
        return viewController
    }
}
