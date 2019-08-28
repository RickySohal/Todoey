//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-25.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }


    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add Category" , message: "Enter the category name", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default){ (action) in
            
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            self.saveData(category: newCategory)
            self.loadData()
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Category Name"
            textField = UITextField
        }
        alert.addAction(action)
        present(alert ,animated: true, completion: nil)
    }
    
    //MARK:- TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].categoryName ?? "No Category Added"
        return cell
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK:- TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.category = categoryArray?[(indexPath?.row)!]
    }
    
    //MARK:- Data Manupulation methods

    func saveData(category: Category){

        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context : \(error)"  )
        }
        tableView.reloadData()
    }
    
    func loadData(){
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
        
    }

    
}
