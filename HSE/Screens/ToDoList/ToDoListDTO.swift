//
//  ToDoListDTO.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 30.10.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ToDoListItem: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let title: String
    let description: String
    let imageName: String?
    let priority: ItemPriority
    
    enum ItemPriority: String, Codable, CaseIterable {
        case low
        case normal
        case high
    }
}

extension ToDoListItem {
    static func prototype() -> ToDoListItem {
        ToDoListItem(
            id: nil,
            title: "",
            description: "",
            imageName: nil,
            priority: .normal
        )
    }
}
