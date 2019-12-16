//
//  Singleton.swift
//  Wow Patient
//
//  Created by Amir on 18/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation
class Singleton: NSObject{
    
    
    static let shareInstance = Singleton()
    
    var appointments = Appointments()
    
    var professionalInfo = Professionalinfo()

    var specialities = Specialities()
    
    
    var medicationInfo = Medication()
    
    var alllergyInfo = Allergy()
    
    var medicalConditionInfo = MedicalCondition()
    var professionalSlotInfo = ProfessionalSlots()
    var professionalServicesInfo = ProfessionalServices()
    
    override init()
    {
    }
}
