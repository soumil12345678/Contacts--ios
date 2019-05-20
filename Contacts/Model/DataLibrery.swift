//
//  DataLibrery.swift
//  Contacts
//
//  Created by Soumil on 11/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit
import CoreData

class DataLibrery: NSObject {    
    static let shared = DataLibrery()
    
    /* Description: Saving Data from Core Data
     - Parameter keys: No Parameter
     - Returns: No Parameter
     */
    func saveData(nameData: String, numberData: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let keyData = DataModel.shared.key.count + 1
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ContactList", in: context)!
        let newContact = NSManagedObject(entity: entity, insertInto: context)
        newContact.setValue(nameData, forKey: "name")
        newContact.setValue(numberData, forKey: "number")
        newContact.setValue(keyData, forKey: "key")
        do {
            try context.save()
            return true
        } catch let error as NSError{
            print(error)
            return false
        }
    }
    
    /* Description: Fetching Data from Core Data
     - Parameter keys: No Parameter
     - Returns: No Parameter
     */
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DataModel.shared.name.removeAll()
        DataModel.shared.number.removeAll()
        DataModel.shared.key.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactList")
        let context = appDelegate.persistentContainer.viewContext
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                DataModel.shared.name.append(data.value(forKey: "name") as! String)
            }
            for data in result as! [NSManagedObject] {
               DataModel.shared.number.append(data.value(forKey: "number") as! String)
            }
            for data in result as! [NSManagedObject] {
                DataModel.shared.key.append(data.value(forKey: "key") as! Int)
            }
        } catch {
            print("Failed fetching Data")
        }
    }
    
}
