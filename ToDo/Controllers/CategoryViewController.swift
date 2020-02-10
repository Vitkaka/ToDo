//
//  CategoryViewController.swift
//  ToDo
//
//  Created by hackeru on 08/02/2020.
//  Copyright © 2020 hackeru. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return categories.count
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CtategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destanation = segue.destination as! TodoListViewControler

        if let indexPath = tableView.indexPathForSelectedRow {
            destanation.selectedCategory = categories[indexPath.row]
        }
    }
    
    func saveCategories() {
        do {
        try contex.save()
        } catch {
            print("error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        let requst : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try contex.fetch(requst)

        } catch {
            print("error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
        
    @IBAction func addButonTapt(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
}

