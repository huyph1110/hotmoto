//
//  MapSelectionViewController.swift
//  hotmoto
//
//  Created by Huy on 4/30/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps

class MapSelectionViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var btnSelect: UIButton!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var myMarker: GMSMarker!
    
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func selectLocation(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    func setupSubViews()  {
        self.view.bringSubview(toFront: btnSelect)
        
        // infoView.removeFromSuperview()
    }
    var myLocation : CLLocation?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: myLocation!.coordinate.latitude, longitude: myLocation!.coordinate.longitude, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        myMarker =  insertMarkerAtPos(coordinate: coordinate, title: nil, detail: nil)
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

}
