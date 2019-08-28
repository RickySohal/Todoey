//
//  ViewController.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-11.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var listArray: Results<Item>?
    var category : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = category?.categoryName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        if let item = listArray?[indexPath.row]{
            cell.textLabel?.text = item.itemName
            cell.accessoryType = item.checked ? .checkmark : .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = listArray?[indexPath.row]{
            do{
                try self.realm.write {
                    item.checked = !item.checked
                    print(item.dateCreated)
                }
            }
            catch{
                print("Error while changing checked property : \(error)")
            }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // ADD: - Item - BarButton Pressed
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Please enter the name of the item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.category{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.itemName = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.item.append(newItem)
                    }
                }
                    catch{
                        print("there was an error: \(error)")
                    }
                }
            self.tableView.reloadData()
               
        }
        alert.addTextField { (uiTextField) in
            
            uiTextField.placeholder = "Enter Text"
            textField = uiTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Function for saving all items from tableView to the custom plist
    
    func saveItems(item: Item){
        try! realm.write {
            realm.add(item)
            tableView.reloadData()
        }
        
    }
    
    // Function for loading all items from custom plist file to the tableView
    
    func loadItems(){
        listArray = category?.item.sorted(byKeyPath: "itemName", ascending: true)
        tableView.reloadData()
    }
    

}

extension TodoViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        listArray = listArray?.filter("itemName CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
