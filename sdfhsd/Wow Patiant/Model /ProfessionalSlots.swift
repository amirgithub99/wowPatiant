//
//  ProfessionalSlots.swift
//  Wow Patient
//
//  Created by Amir on 25/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class ProfessionalSlots: NSObject {
    
    var startDate : String?
    var endDate : String?
    var startTime : String?
    var endTime : String?
    var weekDays : String?
    
    var professionalId : Int?
    var duration : Int?
    var calendarSlotDetailId : Int?
    var professionalSlotArr = NSMutableArray()
    
    override init() {
    }
    public convenience init(slots : NSArray) {
        self.init()
        updateValueWithArray(slotsArr: slots)
    }

    private func updateValueWithArray(slotsArr: NSArray)
    {
        for var i in 0..<slotsArr.count
        {
            let professionalSlotObj = ProfessionalSlots()
            let mainDict = slotsArr[i] as! NSDictionary
            let slotInfoDict = mainDict.value(forKey: "professionalSlotsInfo") as! NSDictionary
            professionalSlotObj.startDate = slotInfoDict.value(forKey: "startDate") as? String
            professionalSlotObj.endDate = slotInfoDict.value(forKey: "endDate") as? String
            professionalSlotObj.startTime = slotInfoDict.value(forKey: "startTime") as? String
            professionalSlotObj.endTime = slotInfoDict.value(forKey: "endTime") as? String
            professionalSlotObj.duration = slotInfoDict.value(forKey: "duration") as? Int
            professionalSlotObj.weekDays = slotInfoDict.value(forKey: "weekDays") as? String
            professionalSlotObj.professionalId = slotInfoDict.value(forKey: "professionalId") as? Int
            professionalSlotObj.calendarSlotDetailId = slotInfoDict.value(forKey: "calendarSlotDetailId") as? Int

            professionalSlotArr.add(professionalSlotObj)
            
            i += 1
        } // end for loop
        
    } // end method
} // end class
