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
    let collectionId = FirestoreManager.shared.collectionId
    var isLoggedIn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let email = "jimmy@gmail.com"
        
        self.delegate = self
        
        //Listening to loginEvent
        NotificationCenter.default.addObserver(self, selector: #selector(emailFetched), name: NSNotification.Name("loggedInNotify"), object: nil)
        
        
        //Listening to firestore db
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
                    print("Print all requests \(userInfo.requests)")
                    print("Print all friends \(userInfo.friends)")
                }
            }
        }
    }
    
    
    
    //MARK: - loginEventDidHappend -
    @objc func emailFetched(notification: NSNotification){

        guard let email = notification.object as? String else{ print("email found nil"); return }
        isLoggedIn = true
    }
}





extension TabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let navigationController = viewController as? UINavigationController,
           let restorationIdentifier = navigationController.restorationIdentifier{
            
            switch restorationIdentifier {
            case "RegisterNVC":
                
                return true
                
                
            default:
                
                if isLoggedIn{
                    
                    return true
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Warning", message: "Please log in or register first", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                    
                    return false
                    
                }
            }
        }
        return true
    }
}

