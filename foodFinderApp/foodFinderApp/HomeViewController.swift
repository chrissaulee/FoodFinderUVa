//
//  HomeViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 11/15/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var GPSLabel: UILabel!
    var locationManager:  CLLocationManager?
    lazy var motionManager = CMMotionManager()
    @IBOutlet weak var minutesToSwitch: UILabel!
    
    // GPS
    func createLocationManager(StartImmediately: Bool){
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manageR: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation:CLLocation = locations[0] as CLLocation
        let lat = String(userLocation.coordinate.latitude)
        let long = String(userLocation.coordinate.longitude)
        GPSLabel.text = lat + ", " + long
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.navigationBar.isHidden = true;
        self.becomeFirstResponder()
        
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                createLocationManager(StartImmediately: true)
            case .authorizedWhenInUse:
                createLocationManager(StartImmediately: true)
            case .denied:
                let alert = UIAlertController(title: "Denied", message: "Location Services are not enabled", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            case .notDetermined:
                createLocationManager(StartImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted:
                let alert = UIAlertController(title: "Denied", message: "Location Services are not enabled", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
        }

        // Do any additional setup after loading the view.
    }
    
    // Device Shake
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.viewDidLoad()
            print("reload")
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
