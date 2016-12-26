
//
//  Meal.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2016. 12. 26..
//  Copyright © 2016년 EDCAN. All rights reserved.
//

struct Bap{
    var date : String
    var lunch : [String]
    var dinner : [String]
    
    init?(dictionary : [String : Any]){
        guard
            let date = dictionary["date"] as? String,
            let lunch = dictionary["lunch"] as? [String],
            let dinner = dictionary["dinner"] as? [String]
        else{
            return nil
        }
        
        self.date = date
        self.lunch = lunch
        self.dinner = dinner
    }
    
    func toDictionary() -> [String : Any]{
        return [
            "date" : self.date,
            "lunch" : self.lunch,
            "dinner" : self.dinner
        ]
    }
}
