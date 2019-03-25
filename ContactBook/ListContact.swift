//
//  Contact.swift
//  ContactBook
//
//  Created by Lauren Simon on 3/19/19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation

class ListContact {
    
    var name: String
    var email: String
    var id: String
    
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let email = dictionary["email"] as! String? ?? ""
        let id = dictionary["id"] as! String? ?? ""
        self.init(name: name, email: email, id: id)
    }
    
}
