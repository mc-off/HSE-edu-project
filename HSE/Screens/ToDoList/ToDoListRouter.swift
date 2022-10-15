
import UIKit


final class ToDoListRouter {
    
    weak var view: (ToDoListDisplayLogic & UIViewController)?
    
    init() {}
}

// MARK: - Routing Logic

extension ToDoListRouter: ToDoListRoutingLogic {
    func routeToAddItem(callback: @escaping () -> Void) {
        let vc = AddItemVC(callback)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        view?.present(vc, animated: true)
    }
    
    func routeToSettings() {
        let vc = SettingsVC()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
