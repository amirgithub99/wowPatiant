//
//  Allergy.swift
//  Wow Patient
//
//  Created by Amir on 23/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Allergy : NSObject
{

    var allergyID : Int?
    var allergyName : String?
    var descriptions : String?
    var selected : String? // doubt string
    var allergyArr = NSMutableArray()
    
    override init()
    {
    }
    public convenience init(allergyArr : NSArray)
    {
      self.init()
        updateValueWithArray(alergyArr: allergyArr)
    }

    private func updateValueWithArray(alergyArr : NSArray)
    {
        for var i in 0..<alergyArr.count
        {
            let allergyObj = Allergy()
            let allergyDict = alergyArr[i] as! NSDictionary
            allergyObj.allergyID = allergyDict.value(forKey: "allergyID") as? Int
            allergyObj.allergyName = allergyDict.value(forKey: "allergyName") as? String
            allergyObj.descriptions = allergyDict.value(forKey: "description") as? String
            allergyObj.selected = allergyDict.value(forKey: "selected") as? String
            
            allergyArr.add(allergyObj)
            
            i += 1
        }// for loop end
    } // func end

} // end class 
