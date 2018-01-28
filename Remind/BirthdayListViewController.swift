//
//  BirthdayListViewController.swift
//  Exp
//
//  Created by Ravi Pinamacha on 1/8/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class BirthdayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
   
    var birthdays : [Birthday] = []
    var filteredData : [Birthday] = []
    var isSearching = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var birthdaysTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdaysTableView.delegate = self
        birthdaysTableView.dataSource = self
        
        searchBar.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
        birthdaysTableView.reloadData()
    }

    @IBAction func addNewBtn(_ sender: Any) {
        performSegue(withIdentifier: "addNewBirthday", sender: self)
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
           filteredData = birthdays
            return
        }
        filteredData = birthdays.filter({ (birthday: Birthday) -> Bool in
            return (birthday.name?.contains(searchText.lowercased()))!
            
        })
        birthdaysTableView.reloadData()
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        searchBar.endEditing(true)
        self.birthdaysTableView.reloadData()
    }
    
    //table view delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        return birthdays.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "birthdaysCell")
        if indexPath.row % 2 == 0 {
             cell.backgroundColor = UIColor(red: 2/255, green: 120/255, blue: 185/255, alpha: 1)
        }else {
             cell.backgroundColor = UIColor(red: 0/255, green: 176/255, blue: 255/255, alpha: 1)
        }
       
        let birthday : Birthday
        
        if isSearching {
            birthday = filteredData[indexPath.row]
        }else {
            birthday = birthdays[indexPath.row]
        }
        
        if birthday.isRemind {
             cell.textLabel?.text = "🔔 \(birthday.name!)"
        }else {
            cell.textLabel?.text = birthday.name
        }
       
        if let date = birthday.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let birthday = birthdays[indexPath.row]
            context.delete(birthday)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            getData()
        }
        birthdaysTableView.reloadData()
    }
    func getData() {
        do {
             birthdays = try context.fetch(Birthday.fetchRequest())
        }catch {
            print("fetching failed")
        }
       
    }
   
}
