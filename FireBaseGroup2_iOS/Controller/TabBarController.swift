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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let email = firestoreManager.email
        
        
        
        
        firestoreManager.db.collection("chris").document(email).addSnapshotListener { documentSnapshot, error in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            
            //let source = document.metadata.hasPendingWrites ? "Local" : "Server"
            
            guard let data = document.data() else{ return }
            
            // Convert NSDictionary or Dictionary to a JSON object
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                
                // Decode the JSON data to UserInfo object
                let decoder = JSONDecoder()
                if let userInfo = try? decoder.decode(UserInfo.self, from: jsonData) {
                    
                    // Now you can use userInfo object
                    //print(userInfo.name)
                    //print(userInfo.email)
                    print(userInfo.requests)
                    print(userInfo.friends)
                    
                    self.firestoreManager.user = userInfo
                    
                    guard let nvcs = self.viewControllers else{ print("nvcs found nil"); return }
                    
                    for nvc in nvcs{
                        guard let nvc = nvc as? UINavigationController else{ print("nvc found nil"); return }
                        
                        if let requestVc = nvc.viewControllers.first as? RequestViewController{
                            
                            DispatchQueue.main.async {
                                //requestVc.tableView.reloadData()
                            }
                        }
                        
                        
                        if let friendVc = nvc.viewControllers.first as? FriendViewController{
                            
                            DispatchQueue.main.async {
                                //friendVc.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

