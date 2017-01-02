//
//  SchoolSearchViewController.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2016. 12. 28..
//  Copyright © 2016년 EDCAN. All rights reserved.
//

import UIKit
import Alamofire

class SchoolSearchViewController : UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{
    let requestBaseUrl = "https://schoool.herokuapp.com"
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let cancelButtonItem = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: nil,
        action: #selector(cancelButtonDidSelect)
    )
    
    var didSelectSchool : ((School) -> Void)?
    var schools : [School] = []
    
    func cancelButtonDidSelect(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "학교 검색"
        self.view.backgroundColor = .white
        
        self.cancelButtonItem.target = self
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.searchBar.delegate = self
        self.searchBar.placeholder = "학교 이름"
        self.tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "schoolCell"
        )
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame  = self.view.bounds
        self.tableView.contentInset.top = 44
        self.tableView.scrollIndicatorInsets.top = 44
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.searchBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.frame = CGRect(
            x : 0,
            y : 64, //statusBar 기본 높이 : 20px, navigationBar 기본 높이 : 44px
            width : self.view.frame.size.width,
            height : 44
        )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let query = searchBar.text
            else{ return }
        
        searchSchools(query : query)
    }
    
    func searchSchools(query : String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let path = "/school/search"
        let requestUrl = requestBaseUrl + path
        let parameters : [String : Any] = [
            "query" : query
        ]
        
        Alamofire.request(requestUrl, parameters : parameters).responseJSON{ response in
            guard
                let datas = response.result.value as? [String : [[String : Any]]],
                let datax = datas["data"]
            else { return }
            
            self.schools = datax.flatMap{
                return School(dictionary: $0)
            }
            
            self.tableView.reloadData()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "schoolCell",
            for : indexPath
        )
        
        var school = self.schools[indexPath.row]
        cell.textLabel?.text = school.name
        
        switch school.type {
        case "유치원" :
            cell.imageView?.image = UIImage(named : "icon_kinder")
        case "초등학교" :
            cell.imageView?.image = UIImage(named : "icon_elementary")
        case "중학교" :
            cell.imageView?.image = UIImage(named : "icon_middle")
        case "고등학교" : 
            cell.imageView?.image = UIImage(named : "icon_high")
        default :
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = self.schools[indexPath.row]
        self.didSelectSchool?(school)
        self.dismiss(animated: true, completion: nil)
    }
}
