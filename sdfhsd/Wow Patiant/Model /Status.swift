//
//  Status.swift
//  Wow Patient
//
//  Created by Amir on 17/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation
class Status: NSObject, NSCoding {
    
    var result : String?
    public var message : Message?
    var messageDict : NSDictionary?
    
    override init()
    {
    }
    required  convenience init(statusDict : Dictionary<String, Any>)
    {
        self.init()
        updateDataWithDict(statusDict: statusDict)
    }
    private func updateDataWithDict(statusDict : Dictionary<String, Any>)
    {
        result = updateValueIfDictContain(key: "result", dict: statusDict)
        messageDict = statusDict["message"]  as? NSDictionary
        message =  Message.init(messageDict: messageDict as! Dictionary)
    }
    private func updateValueIfDictContain(key : String, dict : Dictionary<String, Any>) -> String?
    {
        var fetchValue : Any = ""
        let isContainValue : Bool = dict[key] != nil
        if isContainValue
        {
            fetchValue = dict[key] ?? ""
        }
        if (!(fetchValue is String))
        {
            
            fetchValue = String(describing: fetchValue)
        }
        return fetchValue as? String
    }
    func encode(with aCoder: NSCoder)
    {
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        
    }
    
} // end class




