//
//  GooglePlaces.swift
//
//  Created by Kirby Shabaga on 9/8/14.

// ------------------------------------------------------------------------------------------
// Ref: https://developers.google.com/places/documentation/search#PlaceSearchRequests
//
// Example search
//
// https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise&key=AddYourOwnKeyHere
//
// required parameters: key, location, radius
// ------------------------------------------------------------------------------------------

import CoreLocation
import Foundation
import MapKit

protocol GooglePlacesDelegate {
    
    func googlePlacesSearchResult(_: [MKMapItem])
    
}

class GooglePlaces {
    
    let URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let LOCATION = "location="
    let RADIUS = "radius=" //meter
    var KEY = "key="
    
    var delegate : GooglePlacesDelegate? = nil
    
    // ------------------------------------------------------------------------------------------
    // init requires google.plist with key "places-key"
    // ------------------------------------------------------------------------------------------

    init() {
        /*
        var path = Bundle.main.path(forResource: "google", ofType: "plist")
        var google = NSDictionary(contentsOfFile: path!)
        if let apiKey = google!["places-key"] as? String {
            self.KEY = "\(self.KEY)\(apiKey)"
        } else {
            // TODO: Exception handling
        }*/
        self.KEY = "\(self.KEY)\(GoogleMap_API)"

    }
    
    // ------------------------------------------------------------------------------------------
    // Google Places search with callback
    // ------------------------------------------------------------------------------------------

    func search(
        location : CLLocationCoordinate2D,
        radius : Int,
        query : String,
        callback : @escaping (_ items : [MKMapItem]?, _ errorDescription : String?) -> Void) {
        
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters:  .urlHostAllowed)
        let urlString = "\(URL)\(LOCATION)\(location.latitude),\(location.longitude)&\(RADIUS)\(radius)&\(KEY)&name=\(urlEncodedQuery!)"
            
        let url = NSURL(string: urlString)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: url! as URL, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) -> Void in
            
            if error != nil {
                callback(nil, error?.localizedDescription)
            }
            
            if let statusCode = response as? HTTPURLResponse {
                if statusCode.statusCode != 200 {
                    callback(nil, "Could not continue.  HTTP Status Code was \(statusCode)")
                }
            }
            
            OperationQueue.main.addOperation({ () -> Void in
                callback(GooglePlaces.parseFromData(data: data! ), nil)
            })
            
        } ).resume()
        
    }
    
    
    // ------------------------------------------------------------------------------------------
    // Google Places search with delegate
    // ------------------------------------------------------------------------------------------
    
    func searchWithDelegate(
        location : CLLocationCoordinate2D,
        radius : Int,
        query : String) {
            
        self.search(location: location, radius: radius, query: query) { (items, errorDescription) -> Void in
                if self.delegate != nil {
                    OperationQueue.main.addOperation({ () -> Void in
                        self.delegate!.googlePlacesSearchResult(items!)
                    })
                }
            }
            
    }
    
    // ------------------------------------------------------------------------------------------
    // Parse JSON into array of MKMapItem
    // ------------------------------------------------------------------------------------------

    class func parseFromData(data : Data) -> [MKMapItem] {
        var mapItems = [MKMapItem]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            
            let results = json["results"] as? Array<NSDictionary>
            
            for result in results! {
                
                let name = result["name"] as? String
                let vicinity = result["vicinity"] as? String

                var coordinate : CLLocationCoordinate2D!
                
                if let geometry = result["geometry"] as? NSDictionary {
                    if let location = geometry["location"] as? NSDictionary {
                        let lat = location["lat"] as! CLLocationDegrees
                        let long = location["lng"] as! CLLocationDegrees
                        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = (name ?? "") + " " + (vicinity ?? "")
                        mapItems.append(mapItem)
                    }
                }
            }
        } catch {
            
        }
       
        
        return mapItems
    }
    
}
