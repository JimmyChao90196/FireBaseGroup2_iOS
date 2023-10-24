//
//  RequestTableViewCell.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift



class RequestTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: RequestTableViewCell.self)
    var acceptButton = UIButton()
    var emailLabel = UILabel()
    var onAccept: (() -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTo()
        setup()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    private func addTo(){
        contentView.addSubview(acceptButton)
        contentView.addSubview(emailLabel)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textAlignment = .center
    }
    
    
    private func setup(){
        acceptButton.setTitle("accept", for: .normal)
        acceptButton.setTitleColor(.blue, for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
    }
    
    
    @objc func acceptButtonPressed(){
        onAccept?()
    }
    
    
    
    private func setupConstraint(){
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            acceptButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            acceptButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 20),
            acceptButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
    }
    
    
}
