//
//  MainViewController.swift
//  Exp
//
//  Created by Ravi Pinamacha on 1/8/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var birthdays: UIButton!
    
    @IBOutlet weak var expenses: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdays.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        birthdays.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        birthdays.layer.shadowOpacity = 1.0
        birthdays.layer.shadowRadius = 10
        birthdays.layer.masksToBounds = false
        birthdays.layer.cornerRadius = 4.0
        
        
        expenses.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        expenses.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        expenses.layer.shadowOpacity = 1.0
        expenses.layer.shadowRadius = 10
        expenses.layer.masksToBounds = false
        expenses.layer.cornerRadius = 4.0
    }

    @IBAction func birthdaysBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "MainToBirthdays", sender: self)
    }
    
    @IBAction func expensesBtnPressed(_ sender: Any) {
         performSegue(withIdentifier: "MainToExpenses", sender: self)
    }
}
