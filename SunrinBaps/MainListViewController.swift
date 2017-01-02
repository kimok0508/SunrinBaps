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
    let requestBaseUrl = "https://schoool.herokuapp.com"
    
    let schoolSelectButtonItem = UIBarButtonItem(
        title : "학교 선택",
        style : .plain,
        target : nil,
        action : #selector(shcoolSelectBarButtonItemDidSelect)
    )
    
    let toolBar = UIToolbar()
    let tableView = UITableView()
    var school : School?
    var baps : [Bap] = []
    
    let prevMonthButtonItem = UIBarButtonItem(
        title : "이전달",
        style : .plain,
        target : nil,
        action : nil
    )
    
    let nextMonthButtonItem = UIBarButtonItem(
        title : "다음달",
        style : .plain,
        target : nil,
        action : nil
    )
    
    var date : (year : Int, month : Int)
    
    override init(nibName nibNameOrNil : String?, bundle nibBundleOrNil : Bundle?){
        let today = Date()
        let year = Calendar.current.component(.year, from : today)
        let month = Calendar.current.component(.month, from : today)
        self.date = (year : year, month : month)
        super.init(nibName : nibNameOrNil, bundle : nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveSchool(){
        guard let school = self.school? else { return }
        
        UserDefaults.standard.set(school.toDictionary(), forKey : "school")
        UserDefaults.standard.synchronize()
    }
    
    func loadSchool(){
        guard
            let savedDict = UserDefaults.standard.object(forKey : "school") as? [String : Any],
            let code = savedDict["code"] as? String,
            let name = savedDict["name"] as? String,
            let type = savedDict["type"] as? String
        else{ return }
        
        print(name)
        self.school = School(code : code, name : name, type : type)
    }
    
    func loadBaps(){
        guard let school = self.school else{
            shcoolSelectBarButtonItemDidSelect()
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let path = "/school/\(school.code)/meals"
        let requestUrl = requestBaseUrl + path
        let parameters : [String : Any] = [
            "year" : self.date.year,
            "month" : self.date.month
        ]
        
        Alamofire.request(requestUrl, parameters : parameters).responseJSON{ response in
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
        
        self.prevMonthButtonItem.target = self
        self.prevMonthButtonItem.action = #selector(prevMonthButtonItemDidSelect)
        self.nextMonthButtonItem.target = self
        self.nextMonthButtonItem.action = #selector(nextMonthButtonItemDidSelect)
        
        self.tableView.register(BapCell.self, forCellReuseIdentifier : "bapCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset.bottom = 44
        self.tableView.scrollIndicatorInsets.bottom = 44
        self.toolBar.items = [
            self.prevMonthButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            self.nextMonthButtonItem
        ]
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.toolBar)
        
        loadSchool()
        loadBaps()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
        self.toolBar.frame = CGRect(
            x : 0,
            y : self.view.frame.size.height - 44,
            width : self.view.frame.size.width,
            height : 44
        )
    }
    
    func prevMonthButtonItemDidSelect(){
        var newYear = self.date.year
        var newMonth = self.date.month - 1
        if newMonth <= 0{
            newMonth = 12
            newYear -= 1
        }
        self.date = (year : newYear, month : newMonth)
        loadBaps()
    }
    
    func nextMonthButtonItemDidSelect(){
        var newYear = self.date.year
        var newMonth = self.date.month + 1
        if newMonth >= 13{
            newMonth = 1
            newYear += 1
        }
        self.date = (year : newYear, month : newMonth)
        loadBaps()
    }
    
    func shcoolSelectBarButtonItemDidSelect(){
        let schoolSearchViewController = SchoolSearchViewController()
        schoolSearchViewController.didSelectSchool = {
            self.school = $0
            self.title = $0.name
            self.saveSchool()
            self.loadBaps()
        }
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

