//
//  School.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2017. 1. 2..
//  Copyright © 2017년 EDCAN. All rights reserved.
//

struct School{
    var code : String
    var name : String
    var type : String
    
    init?(dictionary : [String : Any]){
        guard
            let code = dictionary["code"] as? String,
            let name = dictionary["name"] as? String,
            let type = dictionary["type"] as? String
        else{ return nil }
        
        self.code = code
        self.name = name
        self.type = type
    }
    
    init(code : String, name : String, type : String){
        self.code = code
        self.name = name
        self.type = type
    }
    
    func toDictionary() -> [String : Any]{
        return [
            "code" : self.code,
            "name" : self.name,
            "type" : self.type
        ]
    }
}
