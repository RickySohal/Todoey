//
//  ViewController.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-11.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    var listArray = [Item]()
    var category : Category? {
        didSet{
            let predicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", category!.categoryName!)
            loadItems(predicate: predicate)
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = category?.categoryName!
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
            
            let newItem = Item(context: self.context)
            newItem.itemName = textField.text!
            newItem.checked = false
            newItem.parentCategory = self.category
            self.listArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (uiTextField) in
            
            uiTextField.placeholder = "Enter Text"
            textField = uiTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Function for saving all items from tableView to the custom plist
    
    func saveItems(){
        
        do {
            try context.save()
            tableView.reloadData()
        }
        catch{
            print ("Error was there in printing " + "\(error)")
            
        }
        
    }
    
    // Function for loading all items from custom plist file to the tableView
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate){
        request.predicate = predicate
        do {
            listArray = try context.fetch(request)
        }
        catch{
            print ("Error was there in printing " + "\(error)")
        }
        tableView.reloadData()
    }
    

}

extension TodoViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        loadItems(with: request,predicate: predicate)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            let predicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", category!.categoryName!)
            loadItems(predicate: predicate)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
