//
//  GuestViewController.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps

class GuestViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet  var infoView: InfoParkView!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var arrayParks = [Park]()

    
    @IBAction func selectRefresh(_ sender: Any) {
        loadParkingWithDistance(distance: 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.delegate = self
        self.view.addSubview(mapView)
        
        //Location Manager code to fetch current location
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        setupSubViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSubViews()  {
        self.view.bringSubview(toFront: btnList)
        self.view.bringSubview(toFront: btnRefresh)

       // infoView.removeFromSuperview()
    }

    var myLocation : CLLocation?
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if myLocation == nil {
            myLocation = locations.last
            loadParkingWithDistance(distance: 100)

        }else {
            myLocation = locations.last

        }
        let camera = GMSCameraPosition.camera(withLatitude: myLocation!.coordinate.latitude, longitude: myLocation!.coordinate.longitude, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    func insertMarkerAtPos(coordinate: CLLocationCoordinate2D, title: String?, detail: String?) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.title = title
        marker.tracksViewChanges = true
        marker.map = mapView
        marker.snippet = detail
        return marker
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        infoView.showInfo(inView: self.view)
        let park = arrayParks.filter({$0.marker == marker}).last
        infoView.loadPark(park: park!)
        
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.dismiss()

    }
    
    func loadParkingWithDistance(distance: Float) {
        App.showLoadingOnView(view: self.view)
        let request = getParksReq()
        let lat = myLocation!.coordinate.latitude
        let long =  myLocation!.coordinate.longitude
        
        request.position = [Float( long ),Float( lat)]
        request.scope = distance
        
        services.getParks(request: request, success: { (lstPark) in
            
            DispatchQueue.main.async {
                self.mapView.clear()
                self.loadArrayPark(parks: lstPark!)
                App.removeLoadingOnView(view: self.view)

            }
            
        }) { (error) in
            App.removeLoadingOnView(view: self.view)

            App.showAlert(title: error, vc: self, completion: { (_) in
                
            })
        }

    }
    
    func insertPark(coordinate: CLLocationCoordinate2D) {
        App.showLoadingOnView(view: self.view)
        let request = insertParkReq()
        request.location = ["coordinates" : [coordinate.longitude,coordinate.latitude] , "type" : "Point"]

        request.name = "test name"
        request.address = "test address"
        request.phone = "012345"
        request.total = 4
        services.insertPark(request: request, success: {
            App.removeLoadingOnView(view: self.view)

        }) { (error) in
            App.removeLoadingOnView(view: self.view)
            
            App.showAlert(title: error, vc: self, completion: { (_) in
                
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        insertPark(coordinate: coordinate)
    }

    func loadArrayPark(parks: [Park]) {
        arrayParks = parks
        for park in parks {
            //let coordinate = CLLocationCoordinate2D.init(latitude: park.position?.object(forKey: "lat") as! CLLocationDegrees, longitude: park.position?.object(forKey: "long") as! CLLocationDegrees)
           park.marker =  insertMarkerAtPos(coordinate: park.position, title: park.name, detail: park.address)
            
        }
    }
}
