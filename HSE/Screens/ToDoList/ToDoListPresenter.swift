//
//  ToDoListPresenter.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//


final class ToDoListPresenter {
    
    var view: ToDoListDisplayLogic?
    
    init() {}
}

// MARK: - Presentation Logic

extension ToDoListPresenter: ToDoListPresentationLogic {
    func presentUpdate(_ response: ToDoListModels.UpdateItems.Response) {
        view?.displayUpdateItem(.init(item: response.item))
    }
    
    func presentCells(_ response: ToDoListModels.FetchItems.Response) {
        view?.displayCells(.init(items: response.items))
    }
    
    func presentError(_ response: ToDoListModels.Error.Response) {
        view?.displayError(.init(title: response.title))
    }
}
