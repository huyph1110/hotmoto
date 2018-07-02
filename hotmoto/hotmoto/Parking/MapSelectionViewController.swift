//
//  MapSelectionViewController.swift
//  hotmoto
//
//  Created by Huy on 4/30/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps
var delegate: MapSelectionViewControllerDelegate?

protocol MapSelectionViewControllerDelegate {
    func mapSelectionDidSelect(location : CLLocationCoordinate2D, suggest : String? )
    
}
class MapSelectionViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var txvSuggest: UITextView!

    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var myMarker: GMSMarker!
    var coordinate = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()
        txvSuggest.text = nil
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
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        delegate?.mapSelectionDidSelect(location: coordinate, suggest: txvSuggest.text)
        self.dismiss(animated: false, completion: nil)
    }
    
    func setupSubViews()  {
        self.view.bringSubview(toFront: btnSelect)
        self.view.bringSubview(toFront: btnCancel)
        self.view.bringSubview(toFront: txvSuggest)

        // infoView.removeFromSuperview()
    }
    var myLocation : CLLocation?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if myLocation == nil {
            let camera = GMSCameraPosition.camera(withLatitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude, zoom: 17.0)
            self.mapView?.animate(to: camera)

        }
      
        myLocation = locations.last
        
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.mapView.clear()
        myMarker =  insertMarkerAtPos(coordinate: coordinate, title: nil, detail: nil)
        pickPlace(locat: coordinate)
        GooglePlaces().search(location: coordinate, radius: 50, query: "") { (list, error) in
            DispatchQueue.main.async {
                if list == nil {
                    self.txvSuggest.text = nil
                }
                else if list!.count > 0{
                    self.txvSuggest.text = list?.first?.name
                }
            }
        }
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
    func pickPlace(locat: CLLocationCoordinate2D) {
   
    }
    

}
