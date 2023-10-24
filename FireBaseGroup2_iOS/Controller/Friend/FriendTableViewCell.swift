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



class FriendTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: FriendTableViewCell.self)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
    }
    
    
    private func setup(){
        
    }
    
    
    private func setupConstraint(){
        
    }
    
    
}
