//
//  FirestoreManager.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 18.10.2021.
//

import FirebaseFirestore

protocol FirestoreManagerProtocol: AnyObject {
    func read(completion: @escaping (Result<[ToDoListItem], Error>) -> Void)
    func addItem(
        _ item: ToDoListItem,
        merge: Bool,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func deleteItem(
        _ item: ToDoListItem,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
}

final class FirestoreManager: FirestoreManagerProtocol {
    
    enum Collection: String {
        case toDoList = "ToDoList"
    }

    private let db = Firestore.firestore()
    private let collection: Collection
    
    init(_ collection: Collection) {
        self.collection = collection
    }
    
    func read(completion: @escaping (Result<[ToDoListItem], Error>) -> Void) {
        db.collection(collection.rawValue).getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            let items = snapshot?.documents.compactMap { document -> ToDoListItem? in
                try? document.data(as: ToDoListItem.self)
            }
            DispatchQueue.main.async { completion(.success(items ?? [])) }
        }
    }
    
    func addItem(_ item: ToDoListItem, merge: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try db.collection(collection.rawValue).document(item.id ?? "").setData(from: item, merge: merge) { error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
                DispatchQueue.main.async { completion(.success(true)) }
            }
        } catch let error {
            DispatchQueue.main.async { completion(.failure(error)) }
        }
    }
    
    func deleteItem(_ item: ToDoListItem, completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection(collection.rawValue).document(item.id ?? "").delete() { error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            DispatchQueue.main.async { completion(.success(true)) }
        }
    }
}
