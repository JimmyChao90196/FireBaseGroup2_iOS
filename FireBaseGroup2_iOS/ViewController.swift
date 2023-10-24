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


class ViewController: UIViewController {
    
    let firestoreManager = FirestoreManager.shared
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.textColor = .black
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1.0
        titleTextField.placeholder = "Please enter the title"
        return titleTextField
    }()
    
    private let contentTextField: UITextField = {
        let contentTextField = UITextField()
        contentTextField.textColor = .black
        contentTextField.layer.borderColor = UIColor.black.cgColor
        contentTextField.layer.borderWidth = 1.0
        contentTextField.placeholder = "Please enter the content"
        return contentTextField
    }()
    
    private let publishButton: UIButton = {
        let publishButton = UIButton()
        publishButton.setTitle("Publish", for: .normal)
        publishButton.backgroundColor = .black
        publishButton.layer.cornerRadius = 5.0
        return publishButton
    }()
    
    private let tagField: UITextField = {
        let tagField = UITextField()
        tagField.placeholder = "Please separate tags with empty space"
        tagField.layer.borderColor = UIColor.black.cgColor
        tagField.layer.borderWidth = 1.0
        return tagField
    }()
    
    
    //MARK: - viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayouts()
        setUpActions()
        
        tagField.delegate = self
        contentTextField.delegate = self
        titleTextField.delegate = self
      
    }
    private func setUpLayouts() {
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        view.addSubview(tagField)
        view.addSubview(publishButton)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            contentTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            contentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tagField.topAnchor.constraint(equalTo: contentTextField.bottomAnchor, constant: 30),
            tagField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            publishButton.topAnchor.constraint(equalTo: tagField.bottomAnchor, constant: 30),
            publishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            publishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpActions() {
        publishButton.addTarget(self, action: #selector(publishButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Button pressed -
    @objc func publishButtonPressed(_ sender: UIButton) {
        
        guard let title = titleTextField.text, !title.isEmpty,
              let tag = tagField.text, !tag.isEmpty,
              let content = contentTextField.text, !content.isEmpty
        else{fatalError("fields can not be empty")}
        
        let tagArray = tag.components(separatedBy: " ")
        
        firestoreManager.article = Article(
            id: firestoreManager.documentID,
            title: title,
            content: content,
            tag: tagArray,
            createdTime: Timestamp(date: Date())
        )
    }
}


//MARK: - Delegate methods -
extension ViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField{
        case titleTextField: print(titleTextField.text ?? "")
        case contentTextField: print(contentTextField.text ?? "")
        case tagField: print(tagField.text ?? "")
        default: print(tagField.text ?? "")
        }
    }
}

