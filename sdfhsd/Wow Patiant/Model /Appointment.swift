//
//  Appointment.swift
//  Wow Patient
//
//  Created by Amir on 14/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Appointment: NSObject , NSCoding {
    
    enum AppointMentType : Int {
        case Upcoming = 0
        case Completed
        case Cancel
    }

    var date : String?
    var status : String?
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
        
        date = updateValueIfContain( key: "date", dict: dict)
        status = updateValueIfContain(key: "status", dict: dict)
        
    }
    
    private func updateValueIfContain( key : String, dict : Dictionary<String, Any>) -> String? {
        
        var requiredValue : Any = "";
        let containValue : Bool = dict[key] != nil
        if (containValue) {
            requiredValue = dict[key] ?? "";
            if (!(requiredValue is String)) {
                requiredValue = String(describing: requiredValue)
            }
        }
        return requiredValue as? String
    }

    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    public func statusType() -> AppointMentType {
        
        var type : AppointMentType = AppointMentType.Upcoming;
        switch status! {
        case "book":
            type = AppointMentType.Upcoming
            break;
        case "asdfs":
            type = AppointMentType.Completed
            break
        case "asdafs":
            type = AppointMentType.Cancel
            break
        default:
            break
        }
        
        return type;
    } // end methid

    
    
} // end class

