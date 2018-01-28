//
//  ViewController.swift
//  Exp
//
//  Created by Ravi Pinamacha on 12/17/17.
//  Copyright © 2017 Divya. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var expenses : [Expense] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var DataTableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataTableView.delegate = self
        DataTableView.dataSource = self
        navigationItem.title = "My Expenses"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //get data from coredata
        getData()
        //reload table view
        DataTableView.reloadData()
    }
    @IBAction func addExpenses(_ sender: Any) {
        performSegue(withIdentifier: "ShowExpenses", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DataTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! ExpensesCell
        
        let expense = expenses[indexPath.row]
        if let title = expense.name {
            cell.titleLabel.text = title
        }

        cell.amountLabel.text = "$\(expense.amount)"
        
        if let date = expense.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "ShowExpenses", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func getData() {
       do {
            expenses = try context.fetch(Expense.fetchRequest())
        }catch {
            print("fetchingFailed")
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = expenses[indexPath.row]
            context.delete(expense)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            getData()
        }
        tableView.reloadData()
        
    }
}
