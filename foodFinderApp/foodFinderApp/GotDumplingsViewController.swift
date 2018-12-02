//
//  GotDumplingsViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 12/2/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import GoogleMaps

class GotDumplingsViewController: UIViewController {

    var UserLat : String = ""
    var UserLong : String = ""
    var GDLat : String = "38.034046"
    var GDLong : String = "-78.506082"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserLat)
        print(UserLong)

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: Double(UserLat)!, longitude: Double(UserLong)!, zoom:  6)
        let mapView = GMSMapView.map(withFrame:  CGRect.zero, camera:  camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:  Double(UserLat)!, longitude:  Double(UserLong)!)
        marker.title = "You"
        marker.map = mapView
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
