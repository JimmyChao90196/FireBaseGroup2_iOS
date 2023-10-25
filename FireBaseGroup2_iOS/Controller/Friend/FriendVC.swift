//
//  RequestViewController.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit

class FriendViewController: UIViewController{
    
    var tableView = FriendTableView()
    let firestoreManager = FirestoreManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addTo()
        configureConstraint()
        
        firestoreManager.fetchNewData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        //Set navigation title
        navigationItem.title = "\(firestoreManager.email)"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firestoreManager.fetchNewData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

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

extension FriendViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friends = firestoreManager.user?.friends
        return friends?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseIdentifier, for: indexPath) as? FriendTableViewCell else{ return UITableViewCell() }
        
        guard let friends = firestoreManager.user?.friends else {return UITableViewCell()}
        cell.textLabel?.text = friends[indexPath.row]
        //cell.textLabel?.text = "\(indexPath.row)"
        
        
        return cell
        
    }
}

