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
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
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
        self.saveItems()
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
            self.saveItems()
        }
        alert.addTextField { (uiTextField) in
            //code
            uiTextField.placeholder = "Enter Text"
            textField = uiTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // Function for saving all items from tableView to the custom plist
    
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.listArray)
            try data.write(to: self.dataFile!)
            tableView.reloadData()
        }
        catch{
            print ("Error was there in printing " + "\(error)")
            
        }
        
    }
    
    // Function for loading all items from custom plist file to the tableView
    
    
    func loadItems(){
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFile!)
            listArray = try decoder.decode([Item].self, from: data)
            tableView.reloadData()
        }
        catch{
            print ("Error was there in printing " + "\(error)")
            
        }
        
    }
    

}

