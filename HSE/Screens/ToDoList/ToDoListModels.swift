//
//  ToDoListModels.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//




enum ToDoListModels {
    
    enum ItemAction {
        case all
        case add
        case delete
        case edit
    }

    enum Error {
        struct Request {}
        struct Response {
            //let type: ErrorType
            let title: String
        }
        struct ViewModel {
            //let type: ErrorType
            let title: String
        }
    }
    
    enum ErrorType {
        
    }
    
    enum Load {
        struct Request {}
        struct Response {
            let show: Bool
        }
        struct ViewModel {
            let show: Bool
        }
    }
    
    enum UpdateItems {
        struct Request {}
        struct Response {
            let item: ToDoListItem
        }
        struct ViewModel{
            let item: ToDoListItem
        }
    }
    
    enum FetchItems {
        struct Request {
            let item: ToDoListItem?
            let action: ItemAction
            
            init(_ item: ToDoListItem? = nil, _ action: ItemAction) {
                self.action = action
                self.item = item
            }
        }
        struct Response {
            let items: [ToDoListItem]
        }
        struct ViewModel {
            let items: [ToDoListItem]
        }
    }
    
}
