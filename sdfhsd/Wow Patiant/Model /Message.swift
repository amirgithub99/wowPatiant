//
//  Message.swift
//  Wow Patient
//
//  Created by Amir on 17/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Message: NSObject {

    var code : String?
    var type : String?
    var  details : String?
    
    var datiiiiii : String?
    
    
    override init() {
        
    }
    public convenience init(messageDict : Dictionary<String, Any>)
    {
        self.init()
        updateValueWithJsonDict(messageDictt: messageDict)
    }
    private func updateValueWithJsonDict(messageDictt : Dictionary<String, Any>)
    {
     code = updateValueIfDictContain(Key: "code", dict: messageDictt)
     details = updateValueIfDictContain(Key: "details", dict: messageDictt)
        
        datiiiiii = updateValueIfDictContain(Key: "details", dict: messageDictt)
    }
    
    private func updateValueIfDictContain(Key : String, dict : Dictionary<String, Any>) -> String?{
        
        var fetchValue : Any = ""
        let isContainValue : Bool = dict[Key] != nil
        if isContainValue
        {
            fetchValue = dict[Key] ?? ""
        }
        if (!(fetchValue is String))
        {
            fetchValue = String(describing: fetchValue)
        }
        return fetchValue as? String
    } // end method
    
}// end class
