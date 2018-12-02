//
//  HomeViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 11/15/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//
// api key = AIzaSyCyjVz2hWM2TdgAixEyvMVrXiowM44Xgfg

import UIKit
import CoreLocation
import CoreMotion

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var GPSLabel: UILabel!
    var locationManager:  CLLocationManager?
    lazy var motionManager = CMMotionManager()
    @IBOutlet weak var minutesToSwitch: UILabel!
    var lat : String = ""
    var long : String = ""
    
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
        lat = String(userLocation.coordinate.latitude)
        long = String(userLocation.coordinate.longitude)
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
    
    // pass data
    override func prepare(for segue:  UIStoryboardSegue, sender:  Any?){
        if segue.destination is GotDumplingsViewController{
            let vc = segue.destination as? GotDumplingsViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
        }
        
        if segue.destination is TakoNakoViewController{
            let vc = segue.destination as? TakoNakoViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
        }
        
        if segue.destination is ChicFilAViewController{
            let vc = segue.destination as? ChicFilAViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
        }
        
        if segue.destination is ArgoTeaViewController{
            let vc = segue.destination as? ArgoTeaViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
        }
        
        if segue.destination is SubwayViewController{
            let vc = segue.destination as? SubwayViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
        }
        
        if segue.destination is FiveGuysViewController{
            let vc = segue.destination as? FiveGuysViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
        }
        
        if segue.destination is EinsteinBrosViewController{
            let vc = segue.destination as? EinsteinBrosViewController
            vc?.UserLat = lat
            vc?.UserLong = long
            vc?.UserLocation = lat + "," + long
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
