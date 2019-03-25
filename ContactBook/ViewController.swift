//
//  ViewController.swift
//  ContactBook
//
//  Created by Lauren Simon on 3/19/19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var contacts = ContactDownloader()
    var contactList: [ListContact] = []
    let refreshControl = UIRefreshControl()
    var firebaseCount = Int()
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.31, green:0.81, blue:0.28, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        let logo = UIImage(named: "logo")
        let navLogo = UIImageView(image: logo)
        navLogo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = navLogo
        
        refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contactList = []
        var people: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do {
            people = try managedContext.fetch(fetchRequest)
            for person in people {
                print(person)
                self.contactList.append(ListContact(name: person.value(forKeyPath: "name") as? String ?? "", email: person.value(forKeyPath: "email") as? String ?? "", id: person.value(forKeyPath: "id") as? String ?? ""))
            }
        } catch let error as NSError {
            print("could not fetch.")
        }
        contacts.download { results in
            let firebaseContacts = results as! [ListContact]
            self.firebaseCount = firebaseContacts.count
            for contact in firebaseContacts {
                self.contactList.append(contact)
                
            }
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if nameInput.text != "", emailInput.text != "" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            let uuid = NSUUID().uuidString
            person.setValue(uuid, forKeyPath: "id")
            person.setValue(nameInput.text, forKeyPath: "name")
            person.setValue(emailInput.text, forKeyPath: "email")
            contactList.insert(ListContact(name: nameInput.text!, email: emailInput.text!, id: uuid), at: 0)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save")
            }
            nameInput.text = ""
            emailInput.text = ""
            AddAlert.init().showAlert(view: self)
        }
        else {
            ErrorAlert.init().showAlert(view: self)
        }
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        contactCell.textLabel?.text = contactList[indexPath.row].name
        contactCell.textLabel?.font = UIFont(name: "avenir-next-medium", size: 18)
        contactCell.detailTextLabel?.text = contactList[indexPath.row].email
        contactCell.detailTextLabel?.font = UIFont(name: "avenir-next-regular", size: 15)
        contactCell.detailTextLabel?.textColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row < contactList.count-firebaseCount {
            
            var people: [NSManagedObject] = []
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchPredicate = NSPredicate(format: "id == %@", contactList[indexPath.row].id)
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
                print("didnt work")
            }
            contactList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            ContactDeleteAlert.init().showAlert(view: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1
    }
    
}

