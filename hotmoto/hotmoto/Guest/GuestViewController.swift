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

class GuestViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate, PXGoogleDirectionsDelegate {
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet  var infoView: InfoParkView!
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var arrayParks = [Park]()
    var selectedMarker: GMSMarker!
    
    var results: [PXGoogleDirectionsRoute]!

    @IBAction func selectLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectRefresh(_ sender: Any) {
        loadParkingWithDistance(distance: 1000)
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
        let detailVC = DetailParkViewController()
        detailVC.loadPark(park: infoView.myPark!)
        self.present(detailVC, animated: true, completion: nil)
        
    }
    var listParkVC: ListParksViewController?
    
    @objc func loadParkList()  {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        listParkVC = storyboard.instantiateViewController(withIdentifier: "ListParksViewController") as? ListParksViewController
        self.present(listParkVC!, animated: true) {
            self.listParkVC?.loadParks(parks: self.arrayParks)

        }
    }
    
    var myLocation : CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if myLocation == nil {
            myLocation = locations.last
            loadParkingWithDistance(distance: 1000)
            
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
    // MARK: - Mapview

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if selectedMarker != marker {
            infoView.dismiss()
            selectedMarker = marker
            self.showDirectsRoad(from:myLocation!.coordinate , to: marker.position)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        infoView.showInfo(inView: self.view)
        let park = arrayParks.filter({$0.marker == marker}).last
        infoView.loadPark(park: park!)
        self.mapviewFocusToMarker(marker: marker)

    }

    func mapviewBoundAllMarker()  {
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(myLocation!.coordinate)

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
        insertPark(coordinate: coordinate)
    }
    
    // MARK: - Services +

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
                self.mapviewBoundAllMarker()
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
        
                    App.showAlert(title: "Error: \(error.localizedDescription)", vc: self, completion: { (_) in
                        
                    })
                   
                case let .success(request, routes):
                    
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
        
        var bounds = GMSCoordinateBounds()
        
        bounds = bounds.includingCoordinate(myLocation!.coordinate)
        for i in 0 ..< results.count {
            polylinesOnDrawing.append ( results[i].drawOnMap(mapView, approximate: false, strokeColor: UIColor.black, strokeWidth: 3.0))
            bounds = bounds.includingBounds(results[i].bounds!)

        }
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
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

