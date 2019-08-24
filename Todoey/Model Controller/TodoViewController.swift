//
//  ViewController.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-11.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var listArray = [Item]()
    var userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.itemName = "Iphone"
        listArray.append(newItem)

        let newItem2 = Item()
        newItem.itemName = "Android"
        listArray.append(newItem2)

        let newItem3 = Item()
        newItem.itemName = "Windows"
        listArray.append(newItem3)
        
        
        if let list = UserDefaults.standard.array(forKey: "Array") as? [Item] {

            listArray = list
        }
         //Do any additional setup after loading the view.
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = item.itemName
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = listArray[indexPath.row]
        item.checked = !item.checked
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ADD: - Item - BarButton Pressed
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add Item", message: "Please enter the name of the item", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item()
            newItem.itemName = textField.text!
            self.listArray.append(newItem)
            //self.userDefault.set(self.listArray, forKey: "Array")
            self.tableView.reloadData()
        }
        alert.addTextField { (uiTextField) in
            //code
            uiTextField.placeholder = "Enter Text"
            textField = uiTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

