
//  Medication.swift
//  Wow Patient
//
//  Created by Amir on 23/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Medication: NSObject {
    
    
    var  medicationID : Int?
    var  medicationName : String?
    var  frequency : String?
    var  dose : String?
    var  duration : String?
    var  date : String?
    var  doctorName : String?
    var  descriptions : String?

    var medicationArr = NSMutableArray()

    override init()
    {
        
    }
    public convenience  init(medicationDict : NSDictionary)
    {
        self.init()
        updateValueWithDict(dict: medicationDict)
    }
    private func updateValueWithDict(dict : NSDictionary)
    {
       let medicationsArr = dict.value(forKey: "medications") as! NSArray
       for var i in 0..<medicationsArr.count
        {
            let  mediactionInfoDict = medicationsArr[i] as! NSDictionary
            let medicationObj = Medication()
            medicationObj.medicationID = mediactionInfoDict.value(forKey: "medicationID") as? Int
            medicationObj.medicationName = mediactionInfoDict.value(forKey: "medicationName") as? String
           medicationObj.frequency = mediactionInfoDict.value(forKey: "frequency") as? String
           medicationObj.dose = mediactionInfoDict.value(forKey: "dose") as? String
            medicationObj.duration = mediactionInfoDict.value(forKey: "duration") as? String
            medicationObj.descriptions = mediactionInfoDict.value(forKey: "description") as? String
            medicationObj.date = mediactionInfoDict.value(forKey: "date") as? String
            medicationObj.doctorName = mediactionInfoDict.value(forKey: "doctorName") as? String
            medicationArr.add(medicationObj)
            i += 1
        }
    } // end func
    
} // end class
