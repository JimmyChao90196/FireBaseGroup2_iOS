//
//  TabBarController.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class TabBarController: UITabBarController{
    
    let firestoreManager = FirestoreManager.shared
    let collectionId = FirestoreManager.shared.email
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let email = "jimmy@gmail.com"
        
        
        
        
        firestoreManager.db.collection(collectionId).document(email).addSnapshotListener { documentSnapshot, error in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            
            let source = document.metadata.hasPendingWrites ? "Local" : "Server"
            
            guard let data = document.data() else{ return }
            
            // Convert NSDictionary or Dictionary to a JSON object
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                
                // Decode the JSON data to UserInfo object
                let decoder = JSONDecoder()
                if let userInfo = try? decoder.decode(UserInfo.self, from: jsonData) {
                    
                    //Now you can use userInfo object
                    //print(userInfo.name)
                    //print(userInfo.email)
                    print(userInfo.requests)
                    print(userInfo.friends)
                }
            }
        }
    }
}

