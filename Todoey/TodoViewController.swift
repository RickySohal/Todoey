//
//  ViewController.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-11.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var listArray = ["Iphone", "Android" , "Windows"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ADD - Item
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "Please enter the name of the item", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.listArray.append(textField.text!)
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

