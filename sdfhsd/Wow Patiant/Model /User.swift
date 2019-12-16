//
//  User.swift
//  Wow Patient
//
//  Created by Amir on 14/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation


class User: NSObject , NSCoding {
    
    var profilePic : String?
    var token : String?
    var userID : String?
    var userName : String?
    var userProfessionId : String?
    var userRole : String?
    
    override init() {
        
    }
        public convenience init(dict : Dictionary<String, Any>) {
        self.init();
        updateDataWithDict(dict: dict)
    }
    
    /**
    * Update Data with Server Response
    */
    private func updateDataWithDict(dict : Dictionary<String, Any>) {
        
        profilePic = updateValueIfContain( key: "profilePic", dict: dict)
        token = updateValueIfContain(key: "token", dict: dict)
        userID = updateValueIfContain(key: "userID", dict: dict)
        userName = updateValueIfContain(key: "userName", dict: dict)
        userProfessionId = updateValueIfContain(key: "userProfessionId", dict: dict)
        userRole = updateValueIfContain(key: "userRole", dict: dict)
    
    }
    
    private func updateValueIfContain( key : String, dict : Dictionary<String, Any>) -> String?
    {
        var requiredValue : Any = "";
        let containValue : Bool = dict[key] != nil
        if (containValue) {
            requiredValue = dict[key] ?? "";
            if (!(requiredValue is String))
            {
                requiredValue = String(describing: requiredValue)                
            }
        }
        
        return requiredValue as? String
    }
    

    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
} // end methid
