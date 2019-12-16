//
//  Professionalinfo.swift
//  Wow Patient
//
//  Created by Amir on 18/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation
class Professionalinfo: NSObject {
    
    var dob : String?
    var email : String?
    var firstName : String?
    var middleName : String?
    var lastName : String?
    var logoPath : String?// image
    var notes : String?
    var phoneMobile : String?
    var phoneOffice : String?
    var phoneResidence : String?
    var rating : String?
    var specialityName : String?

    var  ssn : Int? // int
    var professionalID : Int? //int
    var professionalType : Int? // int

    var isActive : Bool? // bool
    var audio : Bool?
    var video : Bool?
    var inPerson : Bool?

    var professionAddresss = ProfessionalAdresses()
    var professionAllInfoArr = [Professionalinfo]()
    
    override init() {
        
    }

    public convenience  init(professionalInfoDict : NSDictionary)
    {
        self.init()
        updateValueIfDictContain(preofessionalDict: professionalInfoDict)
    }
    
    public convenience  init(professionalInfoArr : NSArray)
    {
        self.init()
    }
    private func updateValueIfDictContain(preofessionalDict : NSDictionary)
    {
        let professionalObj = Professionalinfo()
        let dict = preofessionalDict
        dob = dict.value(forKey: "dob") as? String
        email = dict.value(forKey: "email") as? String
        firstName = dict.value(forKey: "firstName") as? String
        middleName = dict.value(forKey: "middleName") as? String
        lastName = dict.value(forKey: "lastName") as? String
        notes = dict.value(forKey: "dob") as? String
        phoneMobile = dict.value(forKey: "phoneMobile") as? String
        phoneOffice = dict.value(forKey: "phoneOffice") as? String
        phoneResidence = dict.value(forKey: "phoneResidence") as? String
       specialityName = dict.value(forKey: "specialityName") as? String
       rating = dict.value(forKey: "rating") as? String
       logoPath = dict.value(forKey: "logoPath") as? String
       isActive = dict.value(forKey: "isActive") as? Bool
       audio = dict.value(forKey: "audio") as? Bool
       video = dict.value(forKey: "video") as? Bool
       inPerson = dict.value(forKey: "inPerson") as? Bool
        
       professionalID = dict.value(forKey: "professionalID") as? Int
       professionalType = dict.value(forKey: "professionalType") as? Int
       ssn = dict.value(forKey: "ssn") as? Int
        
        /*  Store */ //problem
        //Singleton.shareInstance.professionalInfo = self
    } // end method
}// end class
