//
//  ViewController.swift
//  JCCoreData
//
//  Created by Mindrose on 01/06/17.
//  Copyright © 2017 Mindrose. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var itemsList = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems))
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemsList")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            itemsList = results as! [NSManagedObject]
            
        } catch {
            print("Error")
        }
        
    }
    func addItems() {
        let alertController = UIAlertController(title: "Type Here", message: "Type..", preferredStyle: .alert)
        
        let conformAction = UIAlertAction(title: "Conform", style: UIAlertActionStyle.default, handler: ({
            (_) in
            let field = alertController.textFields![0]
            let fieldSecond = alertController.textFields![1]
            

            self.saveItems(itemsToSave: field.text!, textToSave: fieldSecond.text!)
            self.tableView.reloadData()
            
            }
        ))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
        textField.placeholder = "Enter The Name."
        
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter The Position."

        }
        alertController.addAction(conformAction)
        alertController.addAction(cancelAction)
        
        let subView = alertController.view.subviews.first!
        
        let alertContentView = subView.subviews.first!
        alertContentView.backgroundColor = UIColor.darkGray
        alertContentView.layer.cornerRadius = 5
        present(alertController, animated: true, completion: nil)
        
    }
    func saveItems(itemsToSave: String,textToSave:String){
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ItemsList", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(itemsToSave, forKey: "name")
        item.setValue(textToSave, forKey: "position")
        
        do {
            try managedContext.save()
            itemsList.append(item)
            
        }
        catch {
            print("error")
            
        }
        
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell
        
        let str :NSManagedObject = itemsList[indexPath.row]
        
        
        cell.nameLabel?.text = str.value(forKey: "name") as? String
        
        cell.positionLabel?.text = str.value(forKey: "position") as? String
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        
        managedContext.delete(itemsList[indexPath.row])
        
        itemsList.remove(at: indexPath.row)
        tableView.reloadData()

    }
}

