//
//  ChicFilAViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 12/2/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase

class ChicFilAViewController: UIViewController {
    
    var UserLat : String = ""
    var UserLong : String = ""
    var UserLocation : String = ""
    var CFALat : String = "38.035762"
    var CFALong : String = "-78.506619"
    var CFALocation: String = "38.035762,-78.506619"
    var urlString : String = ""
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    @IBOutlet weak var chicView: GMSMapView!
    @IBOutlet weak var chicEta: UILabel!
    @IBOutlet weak var chicMenu: UIButton!
    
    @IBAction func chicGetMenu(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://www.chick-fil-a.com/")! as URL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        dbHandle = ref.child("places/chicfila").observe(.value, with: { (data) in
            let times: Int = (data.value as! Int!)
            self.chicEta.text = String(times)
        })
        
        urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(UserLocation)&destination=\(CFALocation)&mode=walking&key=AIzaSyCyjVz2hWM2TdgAixEyvMVrXiowM44Xgfg"
        let url = URL(string:  urlString)
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(UserLat)!, longitude: Double(UserLong)!, zoom:  16)
        self.chicView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:  Double(UserLat)!, longitude:  Double(UserLong)!)
        marker.title = "You"
        marker.map = chicView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude:  Double(CFALat)!, longitude:  Double(CFALong)!)
        marker2.title = "Chic Fil A"
        marker2.map = chicView
        
        // https://stackoverflow.com/questions/42136203/how-to-draw-routes-between-two-locations-in-google-maps-ios-swift - used link to draw route
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
                            self.chicView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.chicView
                        }
                    })
                }
                catch let error as NSError{
                    print("error:/(error)")
                }
            }
        }).resume()
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

