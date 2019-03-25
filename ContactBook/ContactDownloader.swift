//
//  ContactDownloader.swift
//  ContactBook
//
//  Created by Lauren Simon on 3/19/19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol Downloader {
    func download(completed: @escaping([Any]) -> ())
}

class ContactDownloader: Downloader {
    
    var db: Firestore!
    
    func download(completed: @escaping([Any]) -> ()) {
        var contacts: [ListContact] = []
        db = Firestore.firestore()
        db.collection("contact").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** Error: \(error!.localizedDescription)")
                return completed([])
            }
            for contact in querySnapshot!.documents {
                let contact = ListContact(dictionary: contact.data())
                contacts.append(contact)
                print(contact)
            }
            completed(contacts)
        }

    }
    
}
