//
//  HomePageController.swift
//  KonumLA
//
//  Created by Eray İnal on 22.07.2024.
//

import UIKit

class HomePageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var verticalTableView: UITableView!
    
    var events = [CollectionTable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verticalTableView.delegate = self
        verticalTableView.dataSource = self

        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        cell.backgroundColor = .gray
        
        content.text = "Eray"
        
        cell.contentConfiguration=content
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Her bir hücre arasında 10 piksel boşluk
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // Boşluk görünümü (renksiz)
        return headerView
    }
    
    

    

}






struct CollectionTable{
    let date: Date
    let kind: String
    let head: String
    let explanation: String
    
    init(date: Date, kind: String, head: String, explanation: String) {
        self.date = date
        self.kind = kind
        self.head = head
        self.explanation = explanation
    }
}
