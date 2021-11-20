//
//  FirestoreManager.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 18.10.2021.
//

// data слой
// кэширование будет таким:
// 1. получаем данные
// 2. сохраняем
// 3. если есть данные , то сначала показываем из кэша

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
//        if let items = UserDefaults.standard.value(forKey: collection.rawValue) as? [ToDoListItem] {
//            completion(.success(items))
//        }
        db.collection(collection.rawValue).getDocuments { [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            let items = snapshot?.documents.compactMap { document -> ToDoListItem? in
                try? document.data(as: ToDoListItem.self)
            }
            //UserDefaults.standard.set(items, forKey: self?.collection.rawValue ?? "")
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
