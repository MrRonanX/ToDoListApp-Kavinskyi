//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Roman Kavinskyi on 09.03.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var categoryArray : Results<Categories>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
        loadData()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(hexString: "#1e90ff")
        guard let navBar = navigationController?.navigationBar else { fatalError()}
        navBar.backgroundColor = UIColor(hexString: "#1e90ff")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: "#1e90ff")!, returnFlat: true)]
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.setNeedsLayout()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cellBackgroundColor = UIColor(hexString: (categoryArray?[indexPath.row].color)!) {
            cell.backgroundColor = cellBackgroundColor
            cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        }
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! toDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Categories()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.addData(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Caterory Name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation
    
    

    func addData(category : Categories) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Caregoty: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadData() {
        categoryArray = realm.objects(Categories.self)
        tableView.reloadData()
    }
    
    
    override func deleteCell(at indexPath: IndexPath) {
        if let categoryToDelete = categoryArray?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Deletion error occured: \(error)")
            }
        }
        
    }
}





