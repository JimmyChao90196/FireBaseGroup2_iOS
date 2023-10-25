//
//  FindFriendsViewController.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit

class FindFriendsViewController: UIViewController {
    
    let firestoreManager = FirestoreManager.shared
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        
        emailTextField.textColor = .black
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.placeholder = "Please enter friend's email"
        return emailTextField
    }()
    
    private let findButton: UIButton = {
        let findButton = UIButton()
        findButton.setTitle("Find your friend", for: .normal)
        findButton.backgroundColor = .black
        findButton.layer.cornerRadius = 5.0
        return findButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        configureConstraint()
        
        //Set navigation title
        navigationItem.title = "\(firestoreManager.email)"
        
    }
    
    
    func setup(){
        findButton.addTarget(self, action: #selector(findButtonPressed), for: .touchUpInside)

    }
    
    
    
    //MARK: - Button pressed -
    @objc func findButtonPressed(){
        guard let email = emailTextField.text, !email.isEmpty else{
            
            let alertController = UIAlertController(title: "Error", message: "Fields shouldn't be empty", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(alertAction)
            
            present(alertController, animated: true)
            return
        }
        
        firestoreManager.friendMail = email
        firestoreManager.findFriend { result in
            switch result{
            case .success(let document):
                let alertController = UIAlertController(title: "Success", message: "Do you wanna send friend request?", preferredStyle: .alert)
                let comfirmAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    
                    //update friends request queue
                    self.firestoreManager.sendRequest(friendEmail: document.documentID)
                    
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
                alertController.addAction(comfirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                return
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
    private func configureConstraint() {
        view.addSubview(emailTextField)
        view.addSubview(findButton)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            findButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 25),
            findButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            findButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
