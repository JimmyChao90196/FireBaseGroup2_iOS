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

enum Tags: String, CaseIterable {
    case beauty = "Beauty"
    case gossiping = "Gossiping"
    case schoolLife = "School Life"
    
}

class ViewController: UIViewController {
    
    let firestoreManager = FirestoreManager.shared

    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .right
        titleLabel.text = "Title :"
        return titleLabel
    }()
    private let contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .black
        contentLabel.textAlignment = .right
        contentLabel.text = "Content :"
        return contentLabel
    }()
    private let tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.font = UIFont.systemFont(ofSize: 16)
        tagLabel.textColor = .black
        tagLabel.textAlignment = .right
        tagLabel.text = "Tag :"
        return tagLabel
    }()
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.textColor = .black
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1.0
        return titleTextField
    }()
    private let contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.textColor = .black
        contentTextView.layer.borderColor = UIColor.black.cgColor
        contentTextView.layer.borderWidth = 1.0
        return contentTextView
    }()
    private let tagSC: UISegmentedControl = {
        let tagTitle : [String] = [Tags.beauty.rawValue, Tags.gossiping.rawValue, Tags.schoolLife.rawValue]
        let tagSC = UISegmentedControl(items: tagTitle)
        tagSC.selectedSegmentIndex = 0
        // text color
        tagSC.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        tagSC.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        // button color
        tagSC.selectedSegmentTintColor = .black
        // border
        tagSC.layer.borderColor = UIColor.black.cgColor
        tagSC.layer.borderWidth = 1
        return tagSC
    }()
    private let publishButton: UIButton = {
        let publishButton = UIButton()
        publishButton.setTitle("Publish", for: .normal)
        publishButton.backgroundColor = .black
        publishButton.layer.cornerRadius = 5.0
        return publishButton
    }()
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayouts()
        setUpActions()
      
    }
    private func setUpLayouts() {
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(tagLabel)
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(tagSC)
        view.addSubview(publishButton)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalTo: contentLabel.widthAnchor),
            
            titleTextField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            contentTextView.centerYAnchor.constraint(equalTo: contentLabel.centerYAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            contentTextView.heightAnchor.constraint(equalToConstant: 40),

            tagLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 40),
            tagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tagLabel.widthAnchor.constraint(equalTo: contentLabel.widthAnchor),
            
            tagSC.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
            tagSC.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 20),
            tagSC.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tagSC.heightAnchor.constraint(equalToConstant: 40),
            
            publishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            publishButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            publishButton.heightAnchor.constraint(equalToConstant: 40),
            publishButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        contentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    private func setUpActions() {
        tagSC.addTarget(self, action: #selector(selectTag), for: .valueChanged)
        publishButton.addTarget(self, action: #selector(publishButtonPressed), for: .touchUpInside)
    }

    // MARK: - Methods
    
    @objc func selectTag(_ sender: UISegmentedControl) {
        
    }
    
    @objc func publishButtonPressed(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let tag = tagSC.titleForSegment(at: tagSC.selectedSegmentIndex) else {
            return
        }
        guard !contentTextView.text.isEmpty else { return }
      
        firestoreManager.article = Article(
            id: "\(firestoreManager.documentID)",
            title: title,
            content: contentTextView.text,
            tag: tag,
            createdTime: Timestamp(date: Date())
        )

        
    }
}

