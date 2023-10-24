//
//  FirestoreManager.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/23.
//


import FirebaseFirestore
import UIKit

class FirestoreManager {
    static let shared = FirestoreManager()
    
    
    let db =  Firestore.firestore()
    
    var articleRef: DocumentReference {
        db.collection("articles").document()
    }
    
    var userRef: DocumentReference {
        db.collection("users").document()
    }
    
    
    
    
    var article: Article? {
        didSet {
            RegisterUser()
        }
    }
    
    var user: UserInfo = UserInfo(id: "", name: "", email: "", request: [""], friend: [""])
    
    var articles: [String: Any]?
    
    
    private func RegisterUser() {
        
        do {
            try db.collection("articles").document(userRef.documentID).setData(from: article){ (error) in
                if let error = error {
                    print("There was an issue saving data to firestore, \(error)")
                } else {
                    
                    print("Successfully saved data")
                    self.fetchData()
                }
            }
            
            db.collection("articles").document(userRef.documentID).updateData([
                "created_time": FieldValue.serverTimestamp(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    
    
    
    
    
    func fetchData() {
        
        db.collection("users").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("There's an issue retrieving data from Firestroe. \(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        
                        let data = doc.data()
                        
                        print(data)
                    }
                }
            }
        })
    }
}
