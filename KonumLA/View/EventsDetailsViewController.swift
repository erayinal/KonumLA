//
//  EventsDetailsViewController.swift
//  KonumLA
//
//  Created by Eray İnal on 4.12.2024.
//

import UIKit
import MapKit
import Firebase

class EventsDetailsViewController: UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var eventParticipantLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventMapView: MKMapView!
    
    
    var eventData: [String: Any]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventImageView.layer.cornerRadius = 10
        eventMapView.layer.cornerRadius = 10
        
        
        if let eventData = eventData {
            eventTitleLabel.text = eventData["caption"] as? String
            eventDescriptionLabel.text = eventData["eventDescription"] as? String
            eventCategoryLabel.text = eventData["category"] as? String
            
            let numberOfBoys = eventData["numberOfBoys"] as? Int ?? -1
            let numberOfGirls = eventData["numberOfGirls"] as? Int ?? -1
            if numberOfBoys == -1 && numberOfGirls == -1 {
                eventParticipantLabel.text = "Kısıtlama Yok"
            } else if (numberOfBoys == -1 && numberOfGirls>=0){
                eventParticipantLabel.text = "\(numberOfGirls) Kız , ∞ Erkek"
            } else if (numberOfBoys>=0 && numberOfGirls == -1){
                eventParticipantLabel.text = "∞ Kız , \(numberOfBoys) Erkek"
            } else {
                eventParticipantLabel.text = "\(numberOfGirls) Kız , \(numberOfBoys) Erkek"
            }
            
            if let timestamp = eventData["startDate"] as? Timestamp, let endDate = eventData["endDate"] as? Timestamp {
                let startDate = timestamp.dateValue()
                let endDate = timestamp.dateValue()
                eventDateLabel.text = formatDate(startDate) + " - " + formatDate(endDate)
            }
            
            if let latitudeString = eventData["latitude"] as? String,
                           let longitudeString = eventData["longitude"] as? String,
                           let latitude = Double(latitudeString),
               let longitude = Double(longitudeString) {
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                eventMapView.addAnnotation(annotation)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Yakınlaştırılmış bölge
                let region = MKCoordinateRegion(center: coordinate, span: span)
                eventMapView.setRegion(region, animated: true)
                
                fetchAddressForEvent(latitude: latitudeString, longitude: longitudeString) { [weak self] address in
                    DispatchQueue.main.async {
                        self?.eventLocationLabel.text = address ?? "Adres Bulunamadı"
                    }
                }
            }
            
            if let imageUrlArr = eventData["imageUrlArr"] as? [String], let imageUrl = imageUrlArr.first, let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.eventImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
    }
    
    
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    
    
    func fetchAddressForEvent(latitude: String, longitude: String, completion: @escaping (String?) -> Void) {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            completion(nil)
            return
        }
        
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            var address = ""
            if let street = placemark.thoroughfare {
                address += street
            }
            if let subLocality = placemark.subLocality {
                address += ", \(subLocality)"
            }
            if let locality = placemark.locality {
                address += ", \(locality)"
            }
            
            /*
            if let administrativeArea = placemark.administrativeArea {
                address += ", \(administrativeArea)"
            }
            if let country = placemark.country {
                address += ", \(country)"
            }
            */
            
            completion(address)
        }
    }
    
    
    
    
    
    
    
    
    

    
    
    
    
    

}
