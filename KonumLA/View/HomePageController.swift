//
//  HomePageController.swift
//  KonumLA
//
//  Created by Eray İnal on 22.07.2024.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage

class HomePageController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var verticalTableView: UITableView!
    
    //Map
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    let fireStoreDatabase = Firestore.firestore()
    
    var events: [Event] = []
    
    
    //Collection:
    private var collectionView: UICollectionView?
    public let sizeOfCategoriesCircle = 70
    
    let categoriesArr: [CategoriesModel] = [
        CategoriesModel(image: "artCategoryImage2", title: "Sanat"),
        CategoriesModel(image: "musicCategoryImage2", title: "Müzik"),
        CategoriesModel(image: "cookingCategoryImage2", title: "Aşçılık"),
        CategoriesModel(image: "technologyCategoryImage2", title: "Teknoloji"),
        CategoriesModel(image: "funCategoryImage2", title: "Eğlence"),
        CategoriesModel(image: "celebrationCategoryImage2", title: "Kutlama"),
        CategoriesModel(image: "joyCategoryImage2", title: "Neşe"),
        CategoriesModel(image: "sportsCategoryImage2", title: "Spor"),
        CategoriesModel(image: "tripCategoryImage2", title: "Gezi"),
        CategoriesModel(image: "partyCategoryImage", title: "Parti"),
        
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verticalTableView.delegate = self
        verticalTableView.dataSource = self
        
        //Map:
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Seperator:
        verticalTableView.separatorStyle = .singleLine
        verticalTableView.separatorColor = .black
        verticalTableView.contentInset = UIEdgeInsets.zero
        verticalTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        verticalTableView.estimatedSectionHeaderHeight = 0
        verticalTableView.estimatedSectionFooterHeight = 0
        
        //asdf:
        //verticalTableView.register(HomeEventsViewCell.self, forCellReuseIdentifier: "mainEventsCell")
        
        
        
        //Collection:
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: sizeOfCategoriesCircle, height: sizeOfCategoriesCircle + 20)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.register(CircleCollectionViewCell.self, forCellWithReuseIdentifier: CircleCollectionViewCell.identifier)
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        guard let myCollection = collectionView else{
            return
        }
        view.addSubview(myCollection)
        
        
        
        fetchEventsFromFirebase()
        
        showAnnotationsOnMap()
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainEventsCell", for: indexPath) as! HomeEventsViewCell
            let event = events[indexPath.row]
            
        cell.eventTitleLabel.text = event.caption
        cell.eventDescriptionLabel.text = event.eventDescription
        
        // Tarih formatlama
        let formattedStartDate = formatDate(event.startDate)
        cell.eventDateLabel.text = "\(formattedStartDate)"
        
        if let imageUrl = event.imageUrlArr.first, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.eventImageView.image = UIImage(data: data) // İlk resim kapak olarak gösterilir
                    }
                }
            }.resume()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    
    
    
    
    //Collection:
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: 290, width: Int(view.frame.size.width), height: sizeOfCategoriesCircle+20).integral
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCollectionViewCell.identifier, for: indexPath) as! CircleCollectionViewCell
        cell.configure(with: categoriesArr[indexPath.row].image, title: categoriesArr[indexPath.row].title)
        
        return cell
    }
    
    
    
    
    //Map:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
    
    // Firebase Çekme:
    func fetchEventsFromFirebase() {
        fireStoreDatabase.collection("Events")
            .order(by: "date", descending: true) // Tarihe göre sıralama
            .addSnapshotListener { [weak self] (snapshot, error) in
                
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching events: \(error)")
                } else if let snapshot = snapshot {
                    self.events = snapshot.documents.compactMap { doc in
                        let data = doc.data()
                        guard let timestamp = data["date"] as? Timestamp else { return nil }
                        return Event(
                            date: timestamp.dateValue(),
                            id: data["id"] as? String ?? "",
                            uid: data["uid"] as? String ?? "",
                            imageUrlArr: data["imageUrlArr"] as? [String] ?? [],
                            eventDescription: data["eventDescription"] as? String ?? "",
                            startDate: (data["startDate"] as? Timestamp)?.dateValue() ?? Date(),
                            endDate: (data["endDate"] as? Timestamp)?.dateValue() ?? Date(),
                            caption: data["caption"] as? String ?? "",
                            category: data["category"] as? String ?? "",
                            latitude: data["latitude"] as? String ?? "",
                            longitude: data["longitude"] as? String ?? "",
                            numberOfGirls: data["numberOfGirls"] as? Int ?? 0,
                            numberOfBoys: data["numberOfBoys"] as? Int ?? 0,
                            isApprovalRequired: data["isApprovalRequired"] as? Bool ?? false
                        )
                    }
                    DispatchQueue.main.async {
                        self.verticalTableView.reloadData() // Tabloyu güncelle
                    }
                }
            }
    }
    
    
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd HH:mm" // İstediğiniz format bu
        formatter.locale = Locale(identifier: "en_US") // İngilice dil desteği
        return formatter.string(from: date)
    }
    
    
    
    func showAnnotationsOnMap(){
        var annotations : [MKPointAnnotation] = []
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Events").addSnapshotListener { (snapshot, error) in
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents{
                let data = document.data()
                if let latitudeString = data["latitude"] as? String,
                    let longitudeString = data["longitude"] as? String,
                    let latitude = Double(latitudeString),
                    let longitude = Double(longitudeString) {
                    
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        annotation.title = data["caption"] as? String
                        
                        annotations.append(annotation)
                }
                
                for elem in annotations{
                    print(elem.coordinate)
                }
                    
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    
    
    
    
    
    
    
 
    
    
    
        
}
    
    




