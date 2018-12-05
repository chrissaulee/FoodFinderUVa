//
//  TakoNakoViewController.swift
//  foodFinderApp
//
//  Created by Jessica Ewing on 12/2/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase

class TakoNakoViewController: UIViewController {
    
    var UserLat : String = ""
    var UserLong : String = ""
    var UserLocation : String = ""
    var TNLat : String = "38.034077"
    var TNLong : String = "-78.505938"
    var TNLocation: String = "38.034077,-78.505938"
    var urlString : String = ""
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    @IBOutlet weak var takoView: GMSMapView!
    
    @IBOutlet weak var takoMenu: UIButton!
    @IBOutlet weak var takoEta: UILabel!
    @IBAction func getTakoMenu(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://www.yelp.com/biz_photos/el-tako-nako-charlottesville?select=u0KU4rY2vXK1kAxwvNw5uA")! as URL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        dbHandle = ref.child("places/takonako").observe(.value, with: { (data) in
            let times: Int = (data.value as! Int)
            self.takoEta.text = String(times)
        })
        
        urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(UserLocation)&destination=\(TNLocation)&mode=walking&key=AIzaSyCyjVz2hWM2TdgAixEyvMVrXiowM44Xgfg"
        let url = URL(string:  urlString)
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(UserLat)!, longitude: Double(UserLong)!, zoom:  16)
        self.takoView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:  Double(UserLat)!, longitude:  Double(UserLong)!)
        marker.title = "You"
        marker.map = takoView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude:  Double(TNLat)!, longitude:  Double(TNLong)!)
        marker2.title = "Tako Nako"
        marker2.map = takoView
        
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
                            self.takoView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.takoView
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
