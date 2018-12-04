//
//  ProfileViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 11/15/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData


class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    @IBOutlet weak var currentPoints: UILabel!
    
    
    @IBAction func addName(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Enter name:", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter text:"
            textField.delegate = self
            //textField.isSecureTextEntry = true // for password input
        })
        alert.addAction(UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            sender.setTitle(textField?.text, for: [])
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func pickImage(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        //UITextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //this will not work on the simulator because it does not have a camera
    @IBAction func useCamera(_ sender: UIButton) {
        print("this has been called")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("the if statement is trig")
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = UIImagePickerController.SourceType.camera
                        imagePicker.mediaTypes = [kUTTypeImage as String]
                        imagePicker.allowsEditing = false
                        self.present(imagePicker, animated: true, completion: nil)
                        newMedia = true
                        print("the if statement is done")

                 //   }
    }
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            imageView.image = image
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(ProfileViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            else if mediaType.isEqual(to: kUTTypeMovie as String) {
            }
            
        }
    }
    
    @objc func image(image:  UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    print("if statement triggered")
                    currentPoints.text = data.value(forKey: "current") as! String
                }
                print(data.value(forKey: "current"))
            }
            
        } catch {
            print("Failed")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

