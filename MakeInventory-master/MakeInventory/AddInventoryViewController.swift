//
//  AddInventoryViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData

class AddInventoryViewController: UIViewController {
    let coreDataStack = CoreDataStack.instance
    
    var inventory: Inventory?
    
    @IBOutlet weak var inventoryNameField: UITextField!
    @IBOutlet weak var inventoryQuantityField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let inventory = self.inventory {
            inventoryNameField.text = inventory.name
            inventoryQuantityField.text = "\(inventory.quantity)"
        }
    }
    @IBAction func deletePressed(_ sender: Any) {
        if let inventory = self.inventory {
            coreDataStack.viewContext.delete(inventory)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        guard let name = inventoryNameField.text,let quantity = Int64(inventoryQuantityField.text!) else {return}
        if let inventory = self.inventory {
            inventory.name = name
            inventory.quantity = quantity
            inventory.date = Date()
        } else {
            let inv = Inventory(context: coreDataStack.privateContext)
            inv.name = name
            inv.quantity = quantity
            inv.date = Date()
            coreDataStack.saveTo(context: coreDataStack.privateContext)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
