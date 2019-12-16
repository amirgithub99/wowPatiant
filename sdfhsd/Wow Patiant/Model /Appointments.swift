//
//  Appointments.swift
//  Wow Patient
//
//  Created by Amir on 17/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation

class Appointments: NSObject {
    
    var address : String?
    var appointmentServices    : NSArray?
    var appointmentStatusId : Int?
    var date : String?
    var endTime : String?
    var patientId : Int?
    var professionalId : Int?
    var reasonForVisit : String?
    var reevaluation : Bool?
    var slotDetailId : Int?
    var startTime : String?
    var status : String?
    
    var appointmentId : Int?
    var netTotal : Float?
    var duration : Int?

    var video : Bool?
    var audio : Bool?
    var inPerson : Bool?

    var professionalInfoo  = Professionalinfo()
    var professionalAdressess : ProfessionalAdresses?
    var allAppointmentsInfo :Appointments!
    
    var selectedAppointmentDict = NSDictionary()

    public var appointmentCompletedArr  = NSMutableArray()
    public var appointmentUpcomingArr   = NSMutableArray()
    public var appointmentCanceledArr   = NSMutableArray()
    var professionalServicesArr = [ProfessionalServices]()
    var professionalName : String?
    var professionalSpeciality : String?

    
    override init() {
    }
    public convenience init(appointmentArr : NSArray)
    {
        self.init()
        updateValueWithJsonAppointmentArr(appointmentInfoArr: appointmentArr)
    }
    public convenience init(appointmentDict : NSDictionary) {
        self.init()
        updateValueWithSelectedAppointmentDict(appointmentDictionary: appointmentDict)
        
    }
    
    func updateValueWithSelectedAppointmentDict(appointmentDictionary : NSDictionary)
    {
        
        let appintmentDictInfo = appointmentDictionary
        
       address = appintmentDictInfo.value(forKey: "address") as? String
        
        /* return array of dictionary appointmentServices */
        appointmentServices = appintmentDictInfo.value(forKey: "appointmentServices") as? NSArray
        
        appointmentStatusId = appintmentDictInfo.value(forKey: "appointmentStatusId") as? Int
        date = appintmentDictInfo.value(forKey: "date") as? String
        endTime = appintmentDictInfo.value(forKey: "endTime") as? String
        patientId = appintmentDictInfo.value(forKey: "patientId") as? Int
        professionalId = appintmentDictInfo.value(forKey: "professionalId") as? Int
        reasonForVisit = appintmentDictInfo.value(forKey: "reasonForVisit") as? String
        reevaluation = appintmentDictInfo.value(forKey: "reevaluation") as? Bool
        startTime = appintmentDictInfo.value(forKey: "startTime") as? String
        status = appintmentDictInfo.value(forKey: "status") as? String
        
        inPerson = appintmentDictInfo.value(forKey: "inPerson") as? Bool
        audio = appintmentDictInfo.value(forKey: "audio") as? Bool
        video = appintmentDictInfo.value(forKey: "video") as? Bool
        
        appointmentId = appintmentDictInfo.value(forKey: "appointmentId") as? Int
        duration = appintmentDictInfo.value(forKey: "duration") as? Int
        netTotal = appintmentDictInfo.value(forKey: "netTotal") as? Float
        
        slotDetailId = appintmentDictInfo.value(forKey: "slotDetailId") as? Int
        
        /*  Assign value to Professional Class and
         * get  professional object store in Appointments
         */
        let professionalDict = appintmentDictInfo.value(forKey: "professional") as! NSDictionary
        let professionalInfoDict = professionalDict.value(forKey: "professionalInfo") as! NSDictionary
        let professionInfoObj : Professionalinfo  = Professionalinfo.init(professionalInfoDict: professionalInfoDict)
        professionalInfoo = professionInfoObj
        
        /* Assigning value to Profession Address Clas
         * get profesionAddres Obj store in Appointments
         */
        let professionalAddressArr = professionalDict.value(forKey: "professionalAddresses") as! NSArray
        let professionalAddresObj = ProfessionalAdresses.init(addressInfoArr: professionalAddressArr)
        professionalAdressess = professionalAddresObj
        
    } // end method
     func updateValueWithJsonAppointmentArr(appointmentInfoArr : NSArray)
     {
       for var i in 0..<appointmentInfoArr.count
         {
            let appointmentObj = Appointments()
            let appintmentDictInfo = appointmentInfoArr[i] as! NSDictionary
            appointmentObj.address = appintmentDictInfo.value(forKey: "address") as? String
            appointmentObj.appointmentServices = appintmentDictInfo.value(forKey: "appointmentServices") as? NSArray
            appointmentObj.appointmentStatusId = appintmentDictInfo.value(forKey: "appointmentStatusId") as? Int
            appointmentObj.date = appintmentDictInfo.value(forKey: "date") as? String
            appointmentObj.endTime = appintmentDictInfo.value(forKey: "endTime") as? String
            appointmentObj.patientId = appintmentDictInfo.value(forKey: "patientId") as? Int
            appointmentObj.professionalId = appintmentDictInfo.value(forKey: "professionalId") as? Int
            appointmentObj.reasonForVisit = appintmentDictInfo.value(forKey: "reasonForVisit") as? String
            appointmentObj.reevaluation = appintmentDictInfo.value(forKey: "reevaluation") as? Bool
            appointmentObj.startTime = appintmentDictInfo.value(forKey: "startTime") as? String
            appointmentObj.status = appintmentDictInfo.value(forKey: "status") as? String

            appointmentObj.inPerson = appintmentDictInfo.value(forKey: "inPerson") as? Bool
            appointmentObj.audio = appintmentDictInfo.value(forKey: "audio") as? Bool
            appointmentObj.video = appintmentDictInfo.value(forKey: "video") as? Bool

            appointmentObj.appointmentId = appintmentDictInfo.value(forKey: "appointmentId") as? Int
            appointmentObj.duration = appintmentDictInfo.value(forKey: "duration") as? Int
            appointmentObj.netTotal = appintmentDictInfo.value(forKey: "netTotal") as? Float

            appointmentObj.slotDetailId = appintmentDictInfo.value(forKey: "slotDetailId") as? Int

            /*  Assign value to Professional Class and
             * get  professional object store in Appointments       
             */
            let professionalDict = appintmentDictInfo.value(forKey: "professional") as! NSDictionary
            let professionalInfoDict = professionalDict.value(forKey: "professionalInfo") as! NSDictionary
            let professionInfoObj : Professionalinfo  = Professionalinfo.init(professionalInfoDict: professionalInfoDict)
            appointmentObj.professionalInfoo = professionInfoObj
            
            /* Assigning value to Profession Address Clas 
             * get profesionAddres Obj store in Appointments
             */
            let professionalAddressArr = professionalDict.value(forKey: "professionalAddresses") as! NSArray
            let professionalAddresObj = ProfessionalAdresses.init(addressInfoArr: professionalAddressArr)
            appointmentObj.professionalAdressess = professionalAddresObj
            
            /* Store Appointments Objects In Array Base Upon prebook , Book, Cancel */
            let statuStr = appintmentDictInfo.value(forKey: "status") as? String
            
            if (statuStr?.contains("book"))!
            {
              self.appointmentUpcomingArr.add(appointmentObj)
            }
           else if (statuStr?.contains("completed"))!
            {
                self.appointmentCompletedArr.add(appointmentObj)
            }
            else if (statuStr?.contains("cancel"))!
            {
                self.appointmentCanceledArr.add(appointmentObj)
            }
           i += 1
        } // for loop
        
    } // end function
    
    private func updateValueIfDictContainValue(key : String , dict : Dictionary<String, Any>) -> String?{
        
        var fetchValue : Any = ""
        let isContainValue = dict[key] !=  nil
        if isContainValue
        {
            fetchValue = dict[key] ?? ""
        }
        if (!(fetchValue is String)){
            fetchValue = String(describing: fetchValue)
        }
        return fetchValue as? String
    } // end methid
} // end class
