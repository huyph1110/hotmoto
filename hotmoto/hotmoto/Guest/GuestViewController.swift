//
//  GuestViewController.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps
import PXGoogleDirections

class GuestViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate, PXGoogleDirectionsDelegate, ListParksViewControllerDelegate {
    func ListParksViewControllerDidSelectPark(_ park: Park) {
        selectedMarker = park.marker
        self.showDirectsRoad(from:selectedLocat!.coordinate , to: selectedMarker.position)

    }
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet  var infoView: InfoParkView!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var arrayParks = [Park]()
    var selectedPark: Park?
    var selectedMarker: GMSMarker!
    var detailVC = DetailParkViewController.init(nibName: "DetailParkViewController", bundle: nil)
    var results: [PXGoogleDirectionsRoute]!

    @IBAction func selectLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectRefresh(_ sender: Any) {
        loadParking(atlocation: (selectedLocat?.coordinate)!, distance: 1000)
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
        self.view.bringSubview(toFront: btnLogout)
        infoView.btnDetail.addTarget(self, action: #selector(GuestViewController.selectDetail), for: .touchUpInside)
        btnList.addTarget(self, action: #selector(GuestViewController.loadParkList), for: .touchUpInside)
       // infoView.removeFromSuperview()
    }

    @objc func selectDetail()  {
        detailVC.myPark = self.infoView.myPark

        self.present(detailVC, animated: true, completion: {
        })
    }
    
    var listParkVC: ListParksViewController?
    
    @objc func loadParkList()  {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        listParkVC = storyboard.instantiateViewController(withIdentifier: "ListParksViewController") as? ListParksViewController
        listParkVC?.delegate = self
        self.present(listParkVC!, animated: true) {
            self.listParkVC?.loadParks(parks: self.arrayParks)

        }
    }
    
    var selectedLocat : CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if selectedLocat == nil {
            selectedLocat = locations.last
            loadParking(atlocation: (selectedLocat?.coordinate)!, distance: 1000)

        }else {
            selectedLocat = locations.last

        }
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocat!.coordinate.latitude, longitude: selectedLocat!.coordinate.longitude, zoom: 17.0)
        
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
    // MARK: - Mapview

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if selectedMarker != marker {
            selectedPark = arrayParks.filter({$0.marker == marker}).last
            

            infoView.dismiss()
            selectedMarker = marker
            self.showDirectsRoad(from:selectedLocat!.coordinate , to: marker.position)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        infoView.showInfo(inView: self.view)
        infoView.loadPark(park: selectedPark!)
        self.mapviewFocusToMarker(marker: marker)

    }

    func mapviewBoundAllMarker()  {
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(selectedLocat!.coordinate)

        for park  in arrayParks {
            bounds = bounds.includingCoordinate((park.marker?.position)!)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))
    }
    func mapviewFocusToMarker( marker: GMSMarker) {
        mapView.animate(toLocation: marker.position)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.dismiss()
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        startMarker = GMSMarker(position: coordinate)
        startMarker!.title = nil
        startMarker!.tracksViewChanges = true
        startMarker!.map = mapView
        startMarker!.icon = #imageLiteral(resourceName: "pin")
        
        selectedLocat = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        loadParking(atlocation: coordinate, distance: 1000)

    }
    var startMarker: GMSMarker?
    // MARK: - Services +

    func loadParking(atlocation locat:CLLocationCoordinate2D, distance: Float) {
        App.showLoadingOnView(view: self.view)
        let request = getParksReq()
        let lat = locat.latitude
        let long =  locat.longitude
        
        request.position = [Float( long ),Float( lat)]
        request.scope = distance
        
        services.getParks(request: request, success: { (lstPark) in
            
            DispatchQueue.main.async {
                
                self.mapView.clear()
                self.startMarker?.map = self.mapView
                self.loadArrayPark(parks: lstPark!)
                App.removeLoadingOnView(view: self.view)
                self.mapviewBoundAllMarker()
            }
            
        }) { (error) in
            App.removeLoadingOnView(view: self.view)

            self.showAlert(title: error, completion: { (_) in
                
            })
        }

    }
    /*
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
     */

    func loadArrayPark(parks: [Park]) {
        arrayParks = parks
        for park in arrayParks {
            //let coordinate = CLLocationCoordinate2D.init(latitude: park.position?.object(forKey: "lat") as! CLLocationDegrees, longitude: park.position?.object(forKey: "long") as! CLLocationDegrees)
           park.marker =  insertMarkerAtPos(coordinate: park.position, title: park.name, detail: park.address)
            
        }
    }


    func showDirectsRoad(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        
        directionsAPI.delegate = self
        directionsAPI.from = PXLocation.coordinateLocation(from)
        directionsAPI.to = PXLocation.coordinateLocation(to)
        // directionsAPI.mode = modeFromField()
        directionsAPI.transitRoutingPreference = nil
        directionsAPI.trafficModel = nil
        directionsAPI.units = nil
        directionsAPI.alternatives = nil
        directionsAPI.transitModes = Set()
        directionsAPI.featuresToAvoid = Set()
        directionsAPI.departureTime = nil
        directionsAPI.arrivalTime = nil
        directionsAPI.waypoints = [PXLocation]()
        directionsAPI.optimizeWaypoints = nil
        directionsAPI.language = nil
        
        // directionsAPI.region = "fr" // Feature not demonstrated in this sample app
        directionsAPI.calculateDirections { (response) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                switch response {
                case let .error(_, error):
        
                    self.showAlert(title: "Error: \(error.localizedDescription)", completion: { (_) in
                        
                    })
                   
                case let .success(_, routes):
                    
                    self.results = routes
                    self.updateResults()
                    
                    /*
                    if let rvc = self.storyboard?.instantiateViewController(withIdentifier: "Results") as? ResultsViewController {
                        rvc.request = request
                        rvc.results = routes
                        self.present(rvc, animated: true, completion: nil)
                    }
                     */
                    
                }
            })
        }
    }
    
    var polylinesOnDrawing = [GMSPolyline]()
    
    func updateResults()  {

        for poliline in polylinesOnDrawing {
            poliline.map = nil
        }
        polylinesOnDrawing.removeAll()
        
        //remark
        for park in arrayParks {
            park.marker?.map = mapView
        }
        startMarker?.map = mapView
        var bounds = GMSCoordinateBounds()
    
        bounds = bounds.includingCoordinate(selectedLocat!.coordinate)
        bounds = bounds.includingCoordinate(selectedMarker!.position)

        var distance = 0
        for i in 0 ..< results.count {
            polylinesOnDrawing.append ( results[i].drawOnMap(mapView, approximate: true, strokeColor: UIColor.black.withAlphaComponent(0.7), strokeWidth: 5.0))
            bounds = bounds.includingBounds(results[i].bounds!)
            distance += Int(results[i].totalDuration)
        }
        selectedMarker.title = "\(stringDistance(distance))  " + (selectedPark?.name)!
        let padding = 100
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(padding)))
        //results[routeIndex].drawOnMap(mapView, approximate: false, strokeColor: UIColor.purple, strokeWidth: 4.0)
        //results[routeIndex].drawOriginMarkerOnMap(mapView, title: "Origin", color: UIColor.green, opacity: 1.0, flat: true)
        //results[routeIndex].drawDestinationMarkerOnMap(mapView, title: "Destination", color: UIColor.red, opacity: 1.0, flat: true)
    }
    func googleDirectionsWillSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) -> Bool {
        NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
        return true
    }
    
    func googleDirectionsDidSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) {
        NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
        NSLog("\(requestURL.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
    }
    
    func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: Data) {
        NSLog("googleDirections:didReceiveRawDataFromAPI:")
        NSLog(String(data: data, encoding: .utf8)!)
    }
    
    func googleDirectionsRequestDidFail(_ googleDirections: PXGoogleDirections, withError error: NSError) {
        NSLog("googleDirectionsRequestDidFail:withError:")
        NSLog("\(error)")
    }
    
    func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute]) {
        NSLog("googleDirections:didReceiveResponseFromAPI:")
        NSLog("Got \(apiResponse.count) routes")
        for i in 0 ..< apiResponse.count {
            NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
        }
    }
}

