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
    
    var documentID: String {
        "\(articleRef.documentID)"
    }
    
    var article: Article? {
        didSet {
            publishData()
        }
    }
    
    var articles: [String: Any]?
    
    
    
    private func publishData() {
        
        do {
            let ref = db.collection("articles").document(documentID)
            try ref.setData(from: article){ (error) in
                if let error = error {
                    print("There was an issue saving data to firestore, \(error)")
                } else {
                    
                    print("Successfully saved data")
                    self.fetchData()
                }
            }
            
            
            db.collection("articles").document(documentID).updateData([
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
        
        db.collection("articles")
            .order(by: "created_time")
            .getDocuments(completion: { (querySnapshot, error) in
                
                if let error = error {
                    print("There's an issue retrieving data from Firestroe. \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            
                            self.articles = data
                            
                            print(self.articles)
                        }
                    }
                }
            })
    }    
}
