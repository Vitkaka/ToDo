//
//  ViewController.swift
//  ToDo
//
//  Created by hackeru on 04/02/2020.
//  Copyright © 2020 hackeru. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewControler: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        
           }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name

        guard let coloreHex = selectedCategory?.colour else  { fatalError() }
            
        updateNavBar(withHexCode: coloreHex)
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
      updateNavBar(withHexCode: "7CB9FF")
        
    }
    
    
    func updateNavBar(withHexCode coloreHexCode: String) {
        
         guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controler does not exist.")}
        
        guard let navBarColore = UIColor(hexString: coloreHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColore
        
        navBar.tintColor = ContrastColorOf(navBarColore, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColore, returnFlat: true)]
        
        searchBar.barTintColor = navBarColore
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
//            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))")
//
//
//            print("version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
          
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
       
        return cell
    }
    
    //MARK - Table view Delagate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        
       
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    @IBAction func addButtonPrest(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new item \(error)")
                }
            }
            self.tableView.reloadData()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    
   
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


    tableView.reloadData()

    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
               try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item \(error)")
            }
        }
    }
}
//MARK: - Search bar methods

extension TodoListViewControler: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@" ,searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
}


