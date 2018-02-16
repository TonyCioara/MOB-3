//
//  AddEmployeeViewController.swift
//  shop-keep
//
//  Created by Tony Cioara on 2/14/18.
//  Copyright © 2018 Eliel Gordon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddEmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let coreDataStack = CoreDataStack.instance
    
    var shop: Shop?
    var managers = [Employee]()
    var newEmployee: Employee?
    
    var didSelectManager = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let employees = shop?.employees?.allObjects as? [Employee]
            else {return}
        for employee in employees {
            if employee.isManager {
                self.managers.append(employee)
            }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    @IBAction func saveButton(_ sender: Any) {
        if self.didSelectManager == false {
            return
        }
        if self.nameTextField.text == nil {
            return
        }
        
        guard let nameText = nameTextField.text else {return}
        newEmployee?.name = nameText
        var newShop = Shop(context: coreDataStack.viewContext)
        newShop.addToEmployees(newEmployee!)
        coreDataStack.saveTo(context: coreDataStack.viewContext)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.managers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerCell", for: indexPath) as! ManagerCell
        if indexPath.row == 0 {
            cell.nameLabel.text = "I'm a manager"
        } else {
            cell.nameLabel.text = self.managers[indexPath.row - 1].name!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.newEmployee?.isManager = true
        } else {
            self.newEmployee?.isManager = false
            self.newEmployee?.manager = self.managers[indexPath.row - 1]
        }
        self.didSelectManager = true
    }
}
