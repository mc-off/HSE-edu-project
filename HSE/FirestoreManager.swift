//
//  FirestoreManager.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 18.10.2021.
//

import FirebaseFirestore

protocol FirestoreProtocol: AnyObject {
    func getItems(_ completion: @escaping ([Item]) -> Void)
}

final class FirestoreManager: FirestoreProtocol {
    static let shared: FirestoreProtocol = FirestoreManager()
    private let db = Firestore.firestore()
    
    func getItems(_ completion: @escaping ([Item]) -> Void) {
        db.collection("items").getDocuments { snapshot, error in
            guard let snapshot = snapshot,
                  error == nil
            else {
                return
            }
            let items: [Item] = snapshot.documents.compactMap { snap in
                if let title = snap.data()["title"] as? String,
                   let desc = snap.data()["description"] as? String {
                    return Item(
                        title: title,
                        description: desc
                    )
                } else {
                    return Item.init(title: "", description: "")
                }
            }
            completion(items)
        }
    }
}
