//
//  AddDataViewController.swift
//  Exp
//
//  Created by Ravi Pinamacha on 1/7/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import UIKit

class AddDataViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
    
    @IBAction func saveExpenses(_ sender: Any) {
  
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let expense = Expense(context: context)
        
        if let name = nameTextField.text {
            expense.name = name
        }
        if let amount = amountTextField.text {
            expense.amount =  (amount as NSString).doubleValue
        }
        
         expense.date = datePicker.date
    
        // save data into coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
       navigationController?.popViewController(animated: true)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


