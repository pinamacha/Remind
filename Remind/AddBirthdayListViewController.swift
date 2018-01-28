//
//  AddBirthdayListViewController.swift
//  Exp
//
//  Created by Ravi Pinamacha on 1/8/18.
//  Copyright © 2018 Divya. All rights reserved.
//

import UIKit
import UserNotifications

class AddBirthdayListViewController: UIViewController, UITextFieldDelegate {
    
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pickerViewSelectedDate: String = ""
    var day: String = ""
    var month: String = ""
  
    let timeNotificationIdentifier = "timeNotificationIdentifier"
    
    @IBOutlet weak var nameTextField: UITextField!
   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminder: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     datePicker.datePickerMode = .dateAndTime
        nameTextField.delegate = self
       
    }
    
  
    @IBAction func saveBtn(_ sender: Any) {
       
        if (nameTextField.text?.isEmpty)! {
            let myAlert = UIAlertController(title: "name", message: "Enter Name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
        }else {
            let birthday = Birthday(context: context)
            
            birthday.name = nameTextField.text
            
            birthday.date = datePicker.date
            
            birthday.isRemind = reminder.isOn
            
            // save data into coredata
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            if reminder.isOn {
                addLocalNotification(time: datePicker.date as NSDate, title: "Happy Birthday Reminder", descp:nameTextField.text ?? "no task is entered" , regular: false)
            }
            navigationController?.popViewController(animated: true)
        }
 
    }
    
    //keyboard hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func isReminderAction(_ sender: Any) {
        
        if reminder.isOn {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if(settings.authorizationStatus == .authorized){
                         print("suceessfully authorized")
                    
                  
                }else {
                    print("change settings")
                    DispatchQueue.main.async {
                        
                        let uialertView = UIAlertController(title: "settings", message: " Enable Local notificatons in settings if you want this feature", preferredStyle: .alert)
                        
                        
                        uialertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
                            self.reminder.isOn = false
                        }))
                        uialertView.addAction(UIAlertAction(title: "Change Settings", style: .default) { value in
                            let path = UIApplicationOpenSettingsURLString
                            if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                                UIApplication.shared.open(settingsURL,options: [:], completionHandler: nil)
                            }
                        })
                        
                        
                        self.present(uialertView, animated: true, completion: nil)
                    }
                }
            }
            
            
            
        }
        
    }
  
    func addLocalNotification(time:NSDate,title:String,descp:String,regular:Bool){
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = descp
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default()
            
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: time as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: regular)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        } else {
            
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = time as Date
            notification.alertBody = descp
            notification.alertAction = title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
            
        }
    }
    
}
