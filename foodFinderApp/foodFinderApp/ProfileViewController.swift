//
//  ProfileViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 11/15/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    
    @IBOutlet weak var changeProfile: UIButton!
    @IBAction func onClick(_ sender: UIButton) {
        self.useCamera(self)
    }
    @IBAction func useCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = true
        }
    }
    
    @IBAction func useImageLibrary(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes =
                [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = false
        }
    }
    
    // You can add more functions here if needed
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            imageView.image = image
            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self, #selector(CameraViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            else if mediaType.isEqual(to: kUTTypeMovie as String) {
            }
            
        }
    }
    
    func image(image:  UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
