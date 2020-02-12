//
//  CategoryViewController.swift
//  ToDo
//
//  Created by hackeru on 08/02/2020.
//  Copyright © 2020 hackeru. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

        tableView.separatorStyle = .none
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return categories?.count ?? 1
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
        if let category = categories?[indexPath.row] {
        
        cell.textLabel?.text = category.name

            guard let categoryColore = UIColor(hexString: category.colour) else {fatalError()}
            

        cell.backgroundColor = categoryColore
        cell.textLabel?.textColor = ContrastColorOf(categoryColore, returnFlat: true)
        
        }
            
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destanation = segue.destination as! TodoListViewControler

        if let indexPath = tableView.indexPathForSelectedRow {
            destanation.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
            realm.add(category)
            }
        } catch {
            print("error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
         categories = realm.objects(Category.self)
        
         tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                } catch {
                    print("Error deleting category, \(error)")
                }
            }
        }
    
    
        
    @IBAction func addButonTapt(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
                        self.save(category: newCategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
}



