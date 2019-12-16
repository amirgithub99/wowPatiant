//
//  MedicalCondition.swift
//  Wow Patient
//
//  Created by Amir on 24/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class MedicalCondition: NSObject {
    
    
     var selected : String? // data Type
     var medicalConditionName : String?
     var descriptions : String?
     var date : String?
     var medicalConditionID : Int?
    var medicalConditionArr = NSMutableArray()

    override init()
    {
    }
    public convenience init(medicalArr : NSArray)
    {
        self.init()
        updateValueWithArray(medicalCondtionArr: medicalArr)
    }
    private func updateValueWithArray(medicalCondtionArr : NSArray)
    {
        for var i in 0..<medicalCondtionArr.count
        {
            let medicalCondtionObj = MedicalCondition()
            let  medicalCondtionDict = medicalCondtionArr[i] as! NSDictionary
            medicalCondtionObj.medicalConditionName = medicalCondtionDict.value(forKey: "medicalConditionName") as? String
            medicalCondtionObj.date = medicalCondtionDict.value(forKey: "date") as? String
            medicalCondtionObj.descriptions = medicalCondtionDict.value(forKey: "description") as? String
             medicalCondtionObj.selected = medicalCondtionDict.value(forKey: "selected") as? String
            medicalCondtionObj.medicalConditionID = medicalCondtionDict.value(forKey: "medicalConditionID") as? Int
            medicalConditionArr.add(medicalCondtionObj)
            
        i += 1
        } // for Loop End
    }// End Method
    
} // end class
