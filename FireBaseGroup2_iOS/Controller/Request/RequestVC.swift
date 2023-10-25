//
//  RequestViewController.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit

class RequestViewController: UIViewController{
    
    let firestoreManager = FirestoreManager.shared
    var tableView = RequestTableView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addTo()
        configureConstraint()
        
        firestoreManager.fetchNewData()
        tableView.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firestoreManager.fetchNewData()
        tableView.reloadData()
    }
    
    
    
    func addTo(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    func configureConstraint(){
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}



//MARK: - delegate method -

extension RequestViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let requests = firestoreManager.user?.requests
        return requests?.count ?? 0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.reuseIdentifier, for: indexPath)
                as? RequestTableViewCell, let requests = firestoreManager.user?.requests else{ return UITableViewCell() }
        
        
        cell.emailLabel.text = requests[indexPath.row]
        cell.onAccept = {
            
            guard let indexPathToDelete = tableView.indexPath(for: cell) else{ return }
            var emailToMove = requests[indexPathToDelete.row]
            
            //print(indexPathToDelete.row)
            
            self.firestoreManager.user?.requests.remove(at: indexPathToDelete.row)
            self.firestoreManager.updateMyFriends(newEmail: emailToMove)
            self.firestoreManager.updateOthersFriends(friendMail: emailToMove)
        
            
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        return cell
    }
}

