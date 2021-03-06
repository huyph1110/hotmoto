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
        selectedPark = park
        selectedMarker = park.marker
        mapView.selectedMarker = selectedMarker
        self.showDirectsRoad(from: (mapView.myLocation?.coordinate)! , to: selectedMarker.position)

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
        loadParking(atlocation: (selectedLocat?.coordinate)!)
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
        self.view.bringSubviewToFront(btnList)
        self.view.bringSubviewToFront(btnRefresh)
        self.view.bringSubviewToFront(btnLogout)
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
            loadParking(atlocation: (selectedLocat?.coordinate)!)

        }else {
            selectedLocat = locations.last

        }
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocat!.coordinate.latitude, longitude: selectedLocat!.coordinate.longitude, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    func insertMarkerAtPos(coordinate: CLLocationCoordinate2D, title: String?, detail: String?, avail: Bool) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.title = title
        marker.tracksViewChanges = true
        marker.map = mapView
        marker.snippet = detail
        if avail {
            marker.icon = UIImage(named: "pin")
        }
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
            self.showDirectsRoad(from: (mapView.myLocation?.coordinate)! , to: selectedMarker.position)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        infoView.showInfo(inView: self.view)
        infoView.btnBook.addTarget(self, action: #selector(GuestViewController.notification(_:)), for: .touchUpInside)
        infoView.btnBook.isEnabled = isAvailTime(selectedPark!)
        
        infoView.loadPark(park: selectedPark!)
      //  self.mapviewFocusToMarker(marker: marker)

    }
    @objc func notification(_ sender: Any) {
        if notiAvail {
            infoView.btnBook.isEnabled = false
            setnotiduration {
                self.infoView.btnBook.isEnabled = true
            }
            
        }else {
            showAlert(title: "Chờ 5s để gửi lại yêu cầu!") { (_) in
                
            }
            return
        }
        
        //check phone
        self.view.showLoading()
        let req = pushNotificationReq()

        req.content = selectedPark!.id ?? ""
        req.username = selectedPark!.username
        req.title = "Bạn nhận được một yêu cầu gửi xe tại bãi xe: " + selectedPark!.name
        
        services.pushNotification(request: req, success: {
            self.view.removeLoading()
        }) { (error) in
            self.view.removeLoading()
            self.showAlert(title: error, completion: {_ in })
        }
        pendingNotify(15)
    }
    func pendingNotify(_ sec: Int) {
        infoView.btnBook.isEnabled = false
        let time : DispatchTime = .now() + .seconds(sec)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.infoView.btnBook.isEnabled = true
        }
    }
    /*
    func mapviewBoundAllMarker()  {
        print(mapView.padding)
        if arrayParks.count == 0 {
            mapView.animate(toLocation: selectedLocat!.coordinate)
        }else {
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(selectedLocat!.coordinate)
            
            for park  in arrayParks {
                bounds = bounds.includingCoordinate((park.marker?.position)!)
            }
            let padding = 100
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(padding)))

        }

    }
 
    func mapviewFocusToMarker( marker: GMSMarker) {
        //mapView.animate(toLocation: marker.position)
    }
     */
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.dismiss()
        shouldLoadParking = true
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
      
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if shouldLoadParking {
            selectedLocat = CLLocation.init(latitude: position.target.latitude, longitude: position.target.longitude)
            loadParking(atlocation: (selectedLocat?.coordinate)!)
        }
    }
    
    
    func getRadius() -> Float {
        
        let centerCoordinate = getCenterCoordinate()
        // init center location from center coordinate
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        
        return roundf(Float(radius))
    }
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.mapView.center
        let centerCoordinate = self.mapView.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let apoint = CGPoint.init(x: self.mapView.frame.width / 2, y: 0)
        let topCenterCoor = self.mapView.convert(apoint, from: self.mapView)
        let point = self.mapView.projection.coordinate(for: topCenterCoor)
        return point
    }

    var shouldLoadParking = true
    var startMarker: GMSMarker?
    // MARK: - Services +

    func loadParking(atlocation locat:CLLocationCoordinate2D) {
        self.view.showLoading()
        let request = getParksReq()
        let lat = locat.latitude
        let long =  locat.longitude
        
        request.position = [Float( long ),Float( lat)]
        let radius = getRadius()
        request.scope = radius
        
        services.getParks(request: request, success: { (lstPark) in
            
            DispatchQueue.main.async {
                
                self.mapView.clear()
                self.startMarker?.map = self.mapView
                self.loadArrayPark(parks: lstPark!)
                self.view.removeLoading()
               // self.mapviewBoundAllMarker()
            }
            
        }) { (error) in
            self.view.removeLoading()

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
            let avail = isAvailTime(park)
            park.marker =  insertMarkerAtPos(coordinate: park.position, title: park.name, detail: park.address, avail: avail)
            
        }
    }


    func showDirectsRoad(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        shouldLoadParking = false

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
//        var bounds = GMSCoordinateBounds()
//        bounds = bounds.includingCoordinate(selectedLocat!.coordinate)
//        bounds = bounds.includingCoordinate(selectedMarker!.position)

        var distance = 0
        for i in 0 ..< results.count {
            polylinesOnDrawing.append ( results[i].drawOnMap(mapView, approximate: true, strokeColor: ColorsConfig.button_blue.withAlphaComponent(0.7), strokeWidth: 5.0))
//            bounds = bounds.includingBounds(results[i].bounds!)
            distance += Int(results[i].totalDuration)
        }
        selectedMarker.title = "~\(stringDistance(distance))  " + (selectedPark?.name)!
        //let padding = 100
        //mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(padding)))
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

