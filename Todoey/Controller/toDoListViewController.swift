//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class toDoListViewController: SwipeTableViewController {
    
    
    
    var itemForCell : Results<Item>?
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let navBar = navigationController?.navigationBar else { fatalError()}
        if let categoryColor = UIColor(hexString: selectedCategory!.color!) {
            navBar.backgroundColor = categoryColor
            navBar.barTintColor = categoryColor
            navBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
            title = selectedCategory!.name
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(categoryColor, returnFlat: true)]
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(categoryColor, returnFlat: true)]
            searchBar.barTintColor = categoryColor
            searchBar.searchTextField.backgroundColor = FlatWhite()
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = categoryColor
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.setNeedsLayout()
            
        }
    }
    //MARK: - TableView Delegate
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemForCell?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //cell.backgroundColor = UIColor(hexString: itemForCell?[indexPath.row].color ?? "#FFFFFF")
        if let item = itemForCell?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "Nothing To Do Yet"
        }
        if let cellBackgroundColor = UIColor(hexString: selectedCategory!.color!)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemForCell!.count)) {
            cell.backgroundColor = cellBackgroundColor
            cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        }
        return cell
        
    }
    //MARK: - Tap on Cell
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemForCell[indexPath.row])
        
        //        context.delete(itemForCell[indexPath.row])
        //        itemForCell.remove(at: indexPath.row)
        // itemForCell?[indexPath.row].done.toggle()
        
        if let item = itemForCell?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("Error toggling item: \(error)")
            }
        }
        tableView.reloadData()
        
        // addData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    //MARK: - Button Pressed
    
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this action will happen after I press Add Item in the Alert View Controller
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.timeCreated = Date()
                        //newItem.color = UIColor.randomFlat().hexValue()
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error saving ITEM: \(error)")
                }
            }
            self.tableView.reloadData()
            
            //self.addData()
            
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    //MARK: - Add to and Load Data from plist
    
    func loadItems() {
        
        itemForCell = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        if let itemToDelete = itemForCell?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Deletion Error Occured: \(error)")
            }
        }
    }
    
}
//MARK: - UI Search Bar Delegate

extension toDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemForCell = itemForCell?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "timeCreated", ascending: true)
        tableView.reloadData()
        //            let request : NSFetchRequest<Item> = Item.fetchRequest()
        //            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //            loadItems(with: request, searchPredicate: predicate)
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




