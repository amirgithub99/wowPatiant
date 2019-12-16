//
//  ProfessionalServices.swift
//  Wow Patient
//
//  Created by Amir on 26/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation
class ProfessionalServices: NSObject {
 
    var name : String?
    var descriptions : String?
    var id : Int?
    var serviceCategoryID : Int?
    var serviceCharges : Float?
    var professionalServicesArr = NSMutableArray()
    
    override init() {
        
    }
    public convenience init(servicesArr : NSArray)
    {
        self.init()
        updateValueWithArray(services: servicesArr)
    }
    private func updateValueWithArray(services : NSArray)
    {
        for var i in 0..<services.count
        {
            let servisObj = ProfessionalServices()
            let servicesDict = services[i] as! NSDictionary
            servisObj.name = servicesDict.value(forKey: "name") as? String
            servisObj.descriptions = servicesDict.value(forKey: "description") as? String
            servisObj.serviceCharges = servicesDict.value(forKey: "serviceCharges") as? Float
            servisObj.id = servicesDict.value(forKey: "id") as? Int
            servisObj.serviceCategoryID = servicesDict.value(forKey: "serviceCategoryID") as? Int
            professionalServicesArr.add(servisObj)
           i += 1
       } // end for loop
    } // end method
    
} // end class
