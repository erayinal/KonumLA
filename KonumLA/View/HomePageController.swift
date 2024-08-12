//
//  HomePageController.swift
//  KonumLA
//
//  Created by Eray İnal on 22.07.2024.
//

import UIKit

class HomePageController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var verticalTableView: UITableView!
    
    
    
    //Collection:
    private var collectionView: UICollectionView?
    public let sizeOfCategoriesCircle = 70
    
    let categoriesArr: [CategoriesModel] = [
        CategoriesModel(image: "partyCategoryImage", title: "Party"),
        CategoriesModel(image: "funCategoryImage", title: "Fun"),
        CategoriesModel(image: "celebrationCategoryImage", title: "Celebrate"),
        CategoriesModel(image: "joyCategoryImage", title: "Joy"),
        CategoriesModel(image: "musicCategoryImage", title: "Music"),
        CategoriesModel(image: "sportsCategoryImage", title: "Sports"),
        CategoriesModel(image: "tripCategoryImage", title: "Trip"),
        CategoriesModel(image: "technologyCategoryImage", title: "Technology"),
        CategoriesModel(image: "artCategoryImage", title: "Art"),
        CategoriesModel(image: "cookingCategoryImage", title: "Cooking")
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verticalTableView.delegate = self
        verticalTableView.dataSource = self
        
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
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = verticalTableView.dequeueReusableCell(withIdentifier: "mainEventsCell", for: indexPath) as! HomeEventsViewCell
        //var content = cell.defaultContentConfiguration()
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        //content.text = "Eray"
        
        //cell.contentConfiguration=content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 // Her bir hücre arasında 10 piksel boşluk
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    
    
    
    
    //Collection:
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: 285, width: Int(view.frame.size.width), height: sizeOfCategoriesCircle+20).integral
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCollectionViewCell.identifier, for: indexPath) as! CircleCollectionViewCell
        cell.configure(with: categoriesArr[indexPath.row].image, title: categoriesArr[indexPath.row].title)
        
        
        return cell
    }
    
    
    
    
    
    

    

}







