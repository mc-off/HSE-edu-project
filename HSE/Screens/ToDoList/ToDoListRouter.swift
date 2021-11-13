//
//  ToDoListRouter.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//

import UIKit


final class ToDoListRouter {
    
    weak var view: (ToDoListDisplayLogic & UIViewController)?
    
    init() {}
}

// MARK: - Routing Logic

extension ToDoListRouter: ToDoListRoutingLogic {
    func routeToAddItem(callback: @escaping (ToDoListItem) -> Void) {
        let vc = AddItemVC(callback)
        vc.modalPresentationStyle = .formSheet
        view?.present(vc, animated: true)
    }
    
    func routeToSettings() {
        let vc = UIViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
