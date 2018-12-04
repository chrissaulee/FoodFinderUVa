//
//  submitWaitViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 12/3/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

//Used this link to help dismiss the keyboard:
//https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift


import UIKit
import Firebase
import FirebaseDatabase
import CoreData

class submitWaitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    var currentPointValue:Int!
    
    let restaurants = ["Got Dumplings","Tako Nako","Chic Fil A","Argo Tea", "Subway", "Five Guys", "Einstein Bros"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restaurants.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restaurants[row]
    }
    

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var numMinutes: UITextField!
    @IBOutlet weak var places: UIPickerView!
    @IBAction func submitWait(_ sender: UIButton) {
        let selectedValue = restaurants[places.selectedRow(inComponent: 0)]
        var waitTime = Int(numMinutes.text!)
        if waitTime == nil {
            let alertController = UIAlertController(title: "Wait!", message: "Please enter a number in the textfield.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
        // Sets the value of the wait time to the most recent submission (as things might have changed)
        ref = Database.database().reference()
        if selectedValue == "Got Dumplings" {
            self.ref.child("places/gotdumplings").setValue(waitTime)
        } else if selectedValue == "Tako Nako" {
            self.ref.child("places/takonako").setValue(waitTime)
        } else if selectedValue == "Chic Fil A" {
            self.ref.child("places/chicfila").setValue(waitTime)
        } else if selectedValue == "Argo Tea" {
            self.ref.child("places/argotea").setValue(waitTime)
        } else if selectedValue == "Subway" {
            self.ref.child("places/subway").setValue(waitTime)
        } else if selectedValue == "Five Guys" {
            self.ref.child("places/fiveguys").setValue(waitTime)
        } else {
            self.ref.child("places/bros").setValue(waitTime)
        }
            print("here")
            let alert = UIAlertController(title: "Thanks!", message: "Your wait has been added.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Get Points", style: UIAlertAction.Style.default, handler: { [weak alert] (_) in
                print("add 5")
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                //print("NO ERRORS UNTIL HERE")
                let context = appDelegate.persistentContainer.viewContext
                //print("NO ERRORS UNTIL HERE2")
                let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                //print("NO ERRORS UNTIL HERE3")
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                //print("NO ERRORS UNTIL HERE4")
                var newString = String(self.currentPointValue + 5)
                newUser.setValue(newString, forKey: "current")
                //print("WOW NICE")
                do {
                    try context.save()
                    print("Saved properly")
                } catch {
                    print("Failed saving")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        places.delegate = self
        places.dataSource = self
        // Will make sure number keyboard pops up
        self.numMinutes.keyboardType = UIKeyboardType.numberPad
        // Will dismiss the keyboard on any tap
        //Figure this out on the actual device
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print("Printing value...")
                if(data.value(forKey: "current") != nil){
                    self.currentPointValue = Int(data.value(forKey: "current") as! String)
                }
                //print(data.value(forKey: "current"))
            }
            
        } catch {
            print("Failed")
        }
    }
    
    //causing issues for some reason
//    // Call to dismiss the keyboard
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    

}
