//
//  EventShareController.swift
//  KonumLA
//
//  Created by Eray İnal on 7.09.2024.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

class EventShareController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLatitude: CLLocationDegrees?
    var selectedLongitude: CLLocationDegrees?
    var selectedAddress: String?
    
    
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder() //?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinnedLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @IBAction func continueButton(_ sender: Any) {
        if(selectedLatitude == nil || selectedLongitude == nil){
            self.makeAlert(title: "HATA", message: "Konum seçilmedi.")
        }
        performSegue(withIdentifier: "toEventShareSecondPage", sender: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    @objc func pinnedLocation(gestureRecognizer : UILongPressGestureRecognizer){
        
        if(gestureRecognizer.state == .began){
            
            mapView.removeAnnotations(mapView.annotations) // Pinleri kaldrıması için
            
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinate = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            
            let location = CLLocation(latitude: touchedCoordinate.latitude, longitude: touchedCoordinate.longitude)
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Reverse geocoding hatası: \(error.localizedDescription)")
                    annotation.title = "Bilinmeyen Konum"
                } else if let placemark = placemarks?.first {
                    // Ayrıntılı adres bilgilerini al
                    let street = placemark.thoroughfare ?? " "
                    let subThoroughfare = placemark.subThoroughfare ?? " "
                    let city = placemark.locality ?? " "
                    let state = placemark.administrativeArea ?? " "
                    let postalCode = placemark.postalCode ?? " "
                    let country = placemark.country ?? " "

                    let detailedAddress = "\(subThoroughfare) \(street), \(city), \(state), \(postalCode), \(country)"
                    annotation.title = detailedAddress
                    self.selectedAddress = detailedAddress
                }
                
                self.selectedLatitude = touchedCoordinate.latitude
                self.selectedLongitude = touchedCoordinate.longitude
                
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventShareSecondPage" {
            if let destinationVC = segue.destination as? EventShareSecondController {
                destinationVC.latitude = selectedLatitude
                destinationVC.longitude = selectedLongitude
                destinationVC.address = selectedAddress
            }
        }
    }
    
    

}
