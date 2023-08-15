//
//  FirebaseManager.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 21.06.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    enum CollectionDB: String {
        case flows
        case createdFlows
        case config
    }
    
    private init() {}
    
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    
    func getConfig(completion: @escaping (Config?) -> Void) {
        db.collection(CollectionDB.config.rawValue).document("default").getDocument(as: Config.self, completion: { result in
            switch result {
            case .success(let config):
                completion(config)
                break
            case .failure(let error):
                print("Error getting config: \(error)")
                completion(nil)
            }
        })
    }
}
