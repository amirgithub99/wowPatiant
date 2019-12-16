//
//  Specialities.swift
//  Wow Patient
//
//  Created by Amir on 18/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Specialities: NSObject {

    var  name : String?
    var  id : Int?
    var specialitiesInfos = [Specialities]()
    
    override init()
    {
    }
    public convenience init(specialitiesArr : NSArray)
    {
        self.init()
        updateValueWithDict(specilityArr: specialitiesArr)
    }
    private func updateValueWithDict(specilityArr : NSArray)
    {
        /*  adding all Speclitiesinfo in Arrray */
        for var i in 0..<specilityArr.count
        {
            let specialitiesObj = Specialities()
            let specialitiesDict = specilityArr[i] as! NSDictionary
            specialitiesObj.name = specialitiesDict.value(forKey: "name") as? String
            specialitiesObj.id = specialitiesDict.value(forKey: "id") as? Int
            specialitiesInfos.append(specialitiesObj)
            i += 1
        }
        //Singleton.shareInstance.specialities = self
    } // end methd
} // end clas

