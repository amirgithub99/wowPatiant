//
//  ProfessionalAdresses.swift
//  Wow Patient
//
//  Created by Amir on 18/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class ProfessionalAdresses: NSObject{
    
    var addressLine1 : String?
    var addressLine2 : String?
    var countryName : String?
    var stateName : String?
    var zipCode : String?
    var state : Int?
    var country : Int?
    var addressType : Int?
    var professionalAdressArr = [ProfessionalAdresses]()
    
    override init()
    {
        
    }
    public convenience  init(addressInfoArr : NSArray)
    {
        self.init()
        for var i in 0..<addressInfoArr.count
        {
            let professionAddressObj = ProfessionalAdresses()
            let addressDict = addressInfoArr[i] as! NSDictionary
            professionAddressObj.addressLine1 = addressDict.value(forKey: "addressLine1") as? String
            professionAddressObj.addressLine2 = addressDict.value(forKey: "addressLine2") as? String
            professionAddressObj.countryName = addressDict.value(forKey: "countryName") as? String
            professionAddressObj.stateName = addressDict.value(forKey: "stateName") as? String
            professionAddressObj.zipCode = addressDict.value(forKey: "zipCode") as? String
            professionAddressObj.state = addressDict.value(forKey: "state") as? Int
            professionAddressObj.country = addressDict.value(forKey: "country") as? Int
            professionAddressObj.addressType = addressDict.value(forKey: "addressType") as? Int
            professionalAdressArr.append(professionAddressObj)
            
            i += 1
        }
        
    }// end function
}// end class
