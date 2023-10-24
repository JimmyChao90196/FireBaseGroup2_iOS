//
//  FirestoreManager.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/23.
//


import FirebaseFirestore
import UIKit


enum FirestoreError: Error{
    case userNotFound
}



class FirestoreManager {
    static let shared = FirestoreManager()
    
    
    let db =  Firestore.firestore()
    
    var collectionId = "chris"
    
    var articleRef: DocumentReference {
        db.collection("articles").document()
    }
    
    var userRef: DocumentReference {
        db.collection("users").document()
    }
    
    var article: Article? {
        didSet {
            registerUser()
        }
    }
    
    var user: UserInfo? {
        didSet{
            registerUser()
        }
    }
    
    var email: String = "jimmy@gmail.com"
    var friendMail: String = ""
    
    
    
    //MARK: - Register user -
    private func registerUser() {
        
        do {
            try db.collection(collectionId).document(email).setData(from: user){ (error) in
                if let error = error {
                    print("There was an issue saving data to firestore, \(error)")
                } else {
                    print("Successfully saved data")
                }
            }
            
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    
    
    
    //MARK: - update user -
    
    func updateUser() {
        do {
            try db.collection(collectionId).document(email).setData(from: user){ (error) in
                if let error = error {
                    print("There was an issue saving data to firestore, \(error)")
                } else {
                    print("Successfully saved data")
                }
            }
            
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    
    
    
    //MARK: - Find user -
    func findUser( completion: @escaping (Result<QueryDocumentSnapshot, Error>)->Void){
        let colRef = db.collection(collectionId)
        let matchedQuery = colRef.whereField("email", isEqualTo: friendMail)
        matchedQuery.getDocuments { (querySnapshot, err) in
            
            //If friend does not exist
            if querySnapshot!.isEmpty{
                completion(.failure(FirestoreError.userNotFound))
                return
            }
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    //If friend does exsit
                    completion(.success(document))
                }
            }
        }
    }
    
    
    //MARK: - Send Request -
    func sendRequest(friendEmail: String){
        let requestRef = db.collection(collectionId).document(friendEmail)
        
        requestRef.updateData([
            "requests": FieldValue.arrayUnion([email])
        ])
    }
    
    
    
 //MARK: - update friend -
    func updateMyFriends(newEmail: String){
        let friendRef = db.collection(collectionId).document(email)
        
        // Atomically add a new region to the "regions" array field.
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([newEmail])
        ])
    }
    
    
    func updateOthersFriends(friendMail: String){
        let friendRef = db.collection(collectionId).document(friendMail)
        
        // Atomically add a new region to the "regions" array field.
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([email])
        ])
    }
    
    
    
    
    
    
    
    //MARK: - Fetch data -
    func fetchData() {
        db.collection(collectionId).getDocuments(completion: { (querySnapshot, error) in
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
