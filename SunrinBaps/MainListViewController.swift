//
//  ViewController.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2016. 12. 26..
//  Copyright © 2016년 EDCAN. All rights reserved.
//

import UIKit
import Alamofire

class MainListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    let requestUrl = "https://schoool.herokuapp.com/school/B100000658/meals"
    
    let schoolSelectButtonItem = UIBarButtonItem(
        title : "학교 선택",
        style : .plain,
        target : nil,
        action : #selector(shcoolSelectBarButtonItemDidSelect)
    )
    let tableView = UITableView()
    var baps : [Bap] = []
    
    func loadBaps(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(requestUrl).responseJSON{ response in
            guard
                let datas = response.result.value as? [String : [[String : Any]]],
                let datax = datas["data"]
            else{ return }
            
            self.baps = datax.flatMap{
                return Bap(dictionary: $0)
            }
            
            self.tableView.reloadData()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.schoolSelectButtonItem.target = self
        self.navigationItem.rightBarButtonItem = self.schoolSelectButtonItem
        
        self.tableView.register(BapCell.self, forCellReuseIdentifier : "bapCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        
        loadBaps()
    }
    
    func shcoolSelectBarButtonItemDidSelect(){
        print("hello")
        let schoolSearchViewController = SchoolSearchViewController()
        let navigationController = UINavigationController(
            rootViewController : schoolSearchViewController
        )
        self.present(navigationController, animated : true, completion : nil)
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
        ) as! BapCell
        
        let bap = self.baps[indexPath.section]
        
        if indexPath.row == 0{
            cell.titleLabel.text = "점심"
            cell.contentLabel.text = bap.lunch.joined(separator : ", ")
        } else {
            cell.titleLabel.text = "저녁"
            cell.contentLabel.text = bap.dinner.joined(separator : ", ")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bap = self.baps[indexPath.section]
        var title : String
        var content : String
        if indexPath.row == 0{
            title = "점심"
            content = bap.lunch.joined(separator : ", ")
        } else {
            title = "저녁"
            content = bap.dinner.joined(separator : ", ")
        }
        
        return BapCell.height(
            width: tableView.frame.size.width,
            title: title,
            content: content
        )
    }
}

