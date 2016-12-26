//
//  ViewController.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2016. 12. 26..
//  Copyright © 2016년 EDCAN. All rights reserved.
//

import UIKit

class MainListViewController: UIViewController, UITableViewDataSource{
    
    let tableView = UITableView()
    
    var baps : [Bap] = []
    
    func loadBaps(){
        let dummyDictionary : [[String : Any]] = [
            [
                "date" : "2016-12-15",
                "lunch" : ["콩나물국밥", "시금치", "김치"],
                "dinner" : ["치킨", "피자", "햄버거"]
            ],
            [
                "date" : "2016-12-15",
                "lunch" : ["콩나물국밥", "시금치", "김치"],
                "dinner" : ["치킨", "피자", "햄버거"]
            ],
            [
                "date" : "2016-12-15",
                "lunch" : ["콩나물국밥", "시금치", "김치"],
                "dinner" : ["치킨", "피자", "햄버거"]
            ]
        ]
        
        self.baps = dummyDictionary.flatMap{
            return Bap(dictionary: $0)
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier : "bapCell")
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        
        loadBaps()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.baps.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.baps[section].date
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "bapCell",
            for : indexPath
        )
        
        let bap = self.baps[indexPath.section]
        
        if indexPath.row == 0{
            cell.textLabel?.text = "[점심] " + bap.lunch.joined(separator : ", ")
        } else {
            cell.textLabel?.text = "[저녁] " + bap.dinner.joined(separator: ", ")
        }
        return cell
    }
}

