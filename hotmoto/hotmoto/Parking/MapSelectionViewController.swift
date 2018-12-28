//
//  MapSelectionViewController.swift
//  hotmoto
//
//  Created by Huy on 4/30/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import TPKeyboardAvoidingSwift

protocol MapSelectionViewControllerDelegate {
    func mapSelectionDidSelect(location : CLLocationCoordinate2D, suggest : String? )
    
}
class MapSelectionViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsNearby.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = itemsNearby[indexPath.row].name
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let text = itemsNearby[indexPath.row].name
        delegate?.mapSelectionDidSelect(location: coordinate, suggest: text)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var tbvLocate: UITableView!
    @IBOutlet weak var scrollSuggestView: UIScrollView!
    
    var delegate: MapSelectionViewControllerDelegate?
    
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var myMarker: GMSMarker!
    var coordinate = CLLocationCoordinate2D()
    var parkCoordinate: CLLocationCoordinate2D?{
        didSet{
            needCenterMylocation = false
        }
    }
    var itemsNearby = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.delegate = self
        self.view.addSubview(mapView)
        self.tbvLocate.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //Location Manager code to fetch current location
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        setupSubViews()
        if parkCoordinate != nil {
            loadLocation(location: parkCoordinate!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func selectLocation(_ sender: Any) {
        scrollSuggestView.isHidden  = true
    }
    
    @IBAction func skip(_ sender: Any) {
        delegate?.mapSelectionDidSelect(location: coordinate, suggest: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func setupSubViews()  {
        self.view.bringSubviewToFront(btnSelect)
        self.view.bringSubviewToFront(btnCancel)
        self.view.bringSubviewToFront(tbvLocate)
        self.view.bringSubviewToFront(scrollSuggestView)
        scrollSuggestView.isHidden = true

        // infoView.removeFromSuperview()
    }
    var myLocation : CLLocation?
    var needCenterMylocation = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if needCenterMylocation{
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
        GooglePlaces().search(location: coordinate, radius: 50, query: "") { (list, error) in
            DispatchQueue.main.async {
                self.itemsNearby = list!
                self.tbvLocate.reloadData()
                self.scrollSuggestView.isHidden = false

            }
        }
    }
    
    func insertMarkerAtPos(coordinate: CLLocationCoordinate2D, title: String?, detail: String?) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)

        DispatchQueue.main.async {
            marker.title = title
            marker.tracksViewChanges = true
            marker.map = self.mapView
            marker.snippet = detail
        }
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
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.scrollSuggestView.isHidden = true
    }
    func loadLocation(location :CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
        myMarker =  insertMarkerAtPos(coordinate: location, title: nil, detail: nil)

    }
    

}
