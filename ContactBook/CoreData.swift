//
//  CoreData.swift
//  ContactBook
//
//  Created by Lauren Simon on 3/26/19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchData {
    func fetchData() -> [ListContact] {
        var contactList: [ListContact] = []
        var people: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return contactList
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do {
            people = try managedContext.fetch(fetchRequest)
            for person in people {
                contactList.append(ListContact(name: person.value(forKeyPath: "name") as? String ?? "", email: person.value(forKeyPath: "email") as? String ?? "", id: person.value(forKeyPath: "id") as? String ?? ""))
            }
        } catch let error as NSError {
            print("Could not fetch.")
        }
        return contactList
    }
}

class DeleteData {
    func deleteData(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchPredicate = NSPredicate(format: "id == %@", id)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        fetchRequest.predicate = fetchPredicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedUsers = try managedContext.fetch(fetchRequest)
            for fetchedUser in fetchedUsers {
                managedContext.delete(fetchedUser)
                try managedContext.save()
            }
        } catch {
            print("Could not delete.")
        }
    }
}

class AddData {
    func addData(name: String, email: String, uuid: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(uuid, forKeyPath: "id")
        person.setValue(name, forKeyPath: "name")
        person.setValue(email, forKeyPath: "email")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save.")
        }
    }
}

