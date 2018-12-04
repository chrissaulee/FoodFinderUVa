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

class submitWaitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    
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
    }
    
    //causing issues for some reason
//    // Call to dismiss the keyboard
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    

}
