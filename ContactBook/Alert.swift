//
//  ErrorAlert.swift
//  ContactBook
//
//  Created by Lauren Simon on 3/20/19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import UIKit

protocol Alert {
    func showAlert(view: ViewController)
}

class ErrorAlert: Alert {
    func showAlert(view: ViewController) {
        let alert = UIAlertController(title: "Could not add!", message: "Please fill out all the inputs", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}

class AddAlert: Alert {
    func showAlert(view: ViewController) {
        let alert = UIAlertController(title: "Added contact!", message: "Pull to refresh", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}

class ContactDeleteAlert: Alert {
    func showAlert(view: ViewController) {
        let alert = UIAlertController(title: "Cannot delete!", message: "Contact is saved to server", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
