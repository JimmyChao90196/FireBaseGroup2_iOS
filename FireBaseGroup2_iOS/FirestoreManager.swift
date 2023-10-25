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
    case userAlreadyExist
}



class FirestoreManager {
    static let shared = FirestoreManager()
    
    
    let db =  Firestore.firestore()
    
    var collectionId = "users"
    
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
    func findFriend( completion: @escaping (Result<QueryDocumentSnapshot, Error>)->Void){
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
    
    
    func findUser(inputEmail: String ,completion: @escaping (Result<String, Error>)->Void){
        let colRef = db.collection(collectionId)
        let matchedQuery = colRef.whereField("email", isEqualTo: inputEmail)
        matchedQuery.getDocuments { (querySnapshot, err) in
            
            //If user does not exist
            if querySnapshot!.isEmpty{
                completion(.success(inputEmail))
                return
            }
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    //If user does exsit
                    completion(.failure(FirestoreError.userAlreadyExist))
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
    
    
    
    func fetchNewData( completion: @escaping()->Void ){
        let docRef = db.collection(collectionId).document(email)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                guard let data = document.data() else{ return }
                
                // Convert NSDictionary or Dictionary to a JSON object
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    
                    // Decode the JSON data to UserInfo object
                    let decoder = JSONDecoder()
                    if let userInfo = try? decoder.decode(UserInfo.self, from: jsonData) {
                        
                        self.user = userInfo
                        
                        completion()
                        // Now you can use userInfo object
                        //print(userInfo.name)
                        //print(userInfo.email)
                        //print(userInfo.requests)
                        //print(userInfo.friends)
                    }
                    
                    
                    
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}
