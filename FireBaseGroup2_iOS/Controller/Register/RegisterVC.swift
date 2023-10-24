//
//  ViewController.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/23.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class RegisterViewController: UIViewController {
    
    let firestoreManager = FirestoreManager.shared
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.textColor = .black
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.placeholder = "Please enter your name"
        return nameTextField
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.textColor = .black
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.placeholder = "Please enter your email"
        return emailTextField
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Publish", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 5.0
        return loginButton
    }()
    
    
    
    //MARK: - viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureConstraint()
        setupButton()
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        
        //Overall Realtime observation
//        firestoreManager.db.collection("users")
//            .addSnapshotListener { documentSnapshot, error in
//            
//            guard let documentSnapshot = documentSnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//            }
//            documentSnapshot.documents.forEach { document in
//                print("\(document.documentID)")
//            }
//        }
        
    }
    
    
    
    private func configureConstraint() {
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(loginButton)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            nameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupButton() {
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Button pressed -
    @objc func loginButtonPressed(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty else{
            
            let alertController = UIAlertController(title: "Error", message: "Fields shouldn't be empty", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(alertAction)
            
            present(alertController, animated: true)
            return
        }
       
        
        let mockRequests = [
            "chris@gmail.com",
            "billy@gmail.com",
            "aaron@gmail.com"
        ]
        
        let mockFriends = [
            "chris@gmail.com",
            "billy@gmail.com",
            "aaron@gmail.com"
        ]
        
        firestoreManager.email = email
        firestoreManager.user = UserInfo(name: name, email: email, requests: mockRequests, friends: mockFriends)
        
        print(nameTextField.text)
        print(emailTextField.text)
    }
}


//MARK: - Delegate methods -
extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField{
        case nameTextField: print(nameTextField.text ?? "")
        default: print(emailTextField.text ?? "")
        }
    }
}

