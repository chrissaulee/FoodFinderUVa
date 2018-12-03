//
//  EinsteinBrosViewController.swift
//  foodFinderApp
//
//  Created by Lee, Chris Sau (csl7dk) on 12/2/18.
//  Copyright © 2018 Jessica Ewing. All rights reserved.
//

import UIKit
import GoogleMaps

class EinsteinBrosViewController: UIViewController {
    
    var UserLat : String = ""
    var UserLong : String = ""
    var UserLocation : String = ""
    var EBLat : String = "38.031652"
    var EBLong : String = "-78.510806"
    var EBLocation: String = "38.031652,-78.510806"
    var urlString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(UserLocation)&destination=\(EBLocation)&mode=walking&key=AIzaSyCyjVz2hWM2TdgAixEyvMVrXiowM44Xgfg"
        let url = URL(string:  urlString)
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(UserLat)!, longitude: Double(UserLong)!, zoom:  16)
        let mapView = GMSMapView.map(withFrame:  CGRect.zero, camera:  camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:  Double(UserLat)!, longitude:  Double(UserLong)!)
        marker.title = "You"
        marker.map = mapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude:  Double(EBLat)!, longitude:  Double(EBLong)!)
        marker2.title = "Tako Nako"
        marker2.map = mapView
        
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
                            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = mapView
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
