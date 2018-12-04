//
//  GotDumplingsViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 12/2/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase

class GotDumplingsViewController: UIViewController {

    var UserLat : String = ""
    var UserLong : String = ""
    var UserLocation : String = ""
    var GDLat : String = "38.034046"
    var GDLong : String = "-78.506082"
    var GDLocation: String = "38.034046,-78.506082"
    var urlString : String = ""
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var waitButton: UIButton!
    @IBOutlet weak var etaLabel: UILabel!
    
    @IBAction func getMenu(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "http://www.gotdumplingsandtea.com/menu.html")! as URL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading...")
        
        ref = Database.database().reference()
        dbHandle = ref.child("places/gotdumplings").observe(.value, with: { (data) in
            let times: Int = (data.value as! Int!)
            self.etaLabel.text = String(times)
        })
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(self.UserLat)!, longitude: Double(self.UserLong)!, zoom:  16)
        self.myMapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:  Double(UserLat)!, longitude:  Double(UserLong)!)
        marker.title = "You"
        marker.map = myMapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude:  Double(GDLat)!, longitude:  Double(GDLong)!)
        marker2.title = "Got Dumplings"
        marker2.map = myMapView
        
        
        urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(UserLocation)&destination=\(GDLocation)&mode=walking&key=AIzaSyCyjVz2hWM2TdgAixEyvMVrXiowM44Xgfg"
        let url = URL(string:  urlString)
        
        
        
        URLSession.shared.dataTask(with:  url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }
            else{
                do{
                    let json = try JSONSerialization.jsonObject(with:  data!, options:.allowFragments) as! [String:  AnyObject]
                    let routes = json["routes"] as! NSArray
                    
                    OperationQueue.main.addOperation ({
                        for route in routes{
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.myMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.myMapView
                        }
                    })
                }
                catch _ as NSError{
                    print("error:/(error)")
                }
            }
        }).resume()
        
        

        //setUpMap()
        

      //   Do any additional setup after loading the view.
    }

        //References
    // https://stackoverflow.com/questions/42136203/how-to-draw-routes-between-two-locations-in-google-maps-ios-swift - used link to draw route
    //https://stackoverflow.com/questions/40064779/google-maps-gmsmapview-on-custom-uiview
    
//    
//    func onClick(){
//        
//        var ref: DatabaseReference!
//        
//        ref = Database.database().reference()
//    }
    
    
}
