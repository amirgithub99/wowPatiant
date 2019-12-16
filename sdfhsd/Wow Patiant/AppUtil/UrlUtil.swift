//
//  UrlUtil.swift
//  Wow Patient
//
//  Created by Amir on 05/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

class UrlUtil: NSObject {

    // MARK:- Base Url
    class func getBaseURL() -> String
    {
         //return "http://192.168.100.10:9000"
  //      return "http://192.168.100.11:9000"
   // return "http://192.168.100.150:9000"
  return "http://wow-healthcare.com:9000"
    // return "http://192.168.100.28:9000"
   // return "http://192.168.100.12:9000"
     //return "http://192.168.100.12:9000"
        
        //return "http://192.168.100.19:9000"
    // http://192.168.100.150:9000/users/authenticate
   //  return "http://192.168.100.12:9000"

    }
    
    // MARK: - Login Url
    class func getLoginUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let loginUrlKey = "/users/authenticate"
        let loginUrl = baseUrl.appending(loginUrlKey)
         return loginUrl
    }
    // MARK: - SignUp Url
    class func getSignUpUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let signUpUrlKey = "/patient/signUp"
        let signUpUrl = baseUrl.appending(signUpUrlKey)
        return signUpUrl
    }
    // MARK: - Forget Password Url
    class func getForgetPasswordUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let passwordUrlKey = "/users/sendForgotPwdLink"
        let passwordURl = baseUrl.appending(passwordUrlKey)
        return passwordURl
    }
    class func getSuccessCode() -> String
    {
        return "S001"
    }
   // MARK: - Fetch All Specialities
    class func getAllSpecialitiesUlr() -> String
    {
        let baseUrl = self.getBaseURL()
        let specialityKey = "/professional/fetchAllSpecialities"
        let specialityUrl = baseUrl.appending(specialityKey)
        return specialityUrl
    }
     // MARK: - Fetch All Specialities By Name
    class func getSpecialityUrlByName(name : String) -> String
    {
      let baseUrl = self.getBaseURL()
       let specialityKey = "/professional/fetchProfessionalsBySpecialityName?name=".appending(name)
        let specialityNameUrl = baseUrl.appending(specialityKey)
        return specialityNameUrl
    }
    //MARK: - Doctor Detail Url
    class func getDoctorDetailUrl(doctorID : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let doctorKey = "/professional/\(doctorID)/fetchProfessional"
        let doctorUrl = baseUrl.appending(doctorKey)
         return doctorUrl
     }
     //MARK: - CreateAppointUrl
    class func getCreateAppointUrl(professionalId : Int, selectedDate : String) -> String
    {
       // professional/<professionalId>/fetchCalendarSlot?date=21-10-2017
        let baseUrl = self.getBaseURL()
        let createAppointmentKey = "/professional/\(professionalId)/fetchCalendarSlot?date=".appending(selectedDate)
        let createAppointmentURL = baseUrl.appending(createAppointmentKey)
        return createAppointmentURL
    }
    
    // MARK: - AllAppointment By AppointmentID
    class func getPatientAppointmentsUrl(patiantId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let appointmentKey = "/patient/appointment/\(patiantId)/fetchAppointment"
        let appointmentURL = baseUrl.appending(appointmentKey)
        return appointmentURL
    }
    // MARK: - Get All Services URL
    class func getAllServicesUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let allServicesKey = "/common/fetchServices"
        let allServicesUrl = baseUrl.appending(allServicesKey)
        return allServicesUrl
    }
    class func getProfessionalServicesUrl(professionId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let servicesKey = "/professional/services/\(professionId)/fetchProfessionalServices"
        let servicesUrl = baseUrl.appending(servicesKey)
        return servicesUrl
    }
    // MARK: - Appointment By AppointmentID
    class func getAppointmentbyfetchingAppointmentID(appointmentId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let appointmentKey = "/appointment/\(appointmentId)/fetchAppointment"
        let appointmentURL = baseUrl.appending(appointmentKey)
        return appointmentURL
    }
    // MARK: - createAppointmentURl
    class func getCreateAppointmentUrl(selectedDate: String) -> String
    {
     let baseUrl = self.getBaseURL()
     let createAppointmentKey = "professional/<professionalId>/fetchCalendarSlot?date=".appending(selectedDate)
        let createAppointmentURl = baseUrl.appending(createAppointmentKey)
       return createAppointmentURl
    }
    ///patient/appointment/$id<.+>/fetchAppointment
    
    class func getAppointmenetUrlByAppointmentId(appointentId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let appointmentIdKey = "/appointment/\(appointentId)/fetchAppointment"
        let appointmentIdUrl = baseUrl.appending(appointmentIdKey)
        return appointmentIdUrl
    }
    // MARK: - Fetch ALL Alergies byPatientId
    class func getAllergyUrl(patiantId : Int) -> String
    {
        ///patient/allergies/$id<.+>/fetchAll
        let baseUrl = self.getBaseURL()
        let allergyKey = "/patient/allergies/\(patiantId)/fetchAll"
        let allergyUrl = baseUrl.appending(allergyKey)
        return allergyUrl
    }
    class func getAddAllergyUrl(patiantId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let addAllergyKey = "/patient/\(patiantId)/patientMedicalAllergy/add"
        let addAllergyUrl = baseUrl.appending(addAllergyKey)
        return addAllergyUrl
    }
    // MARK: - Fetch  Alergies Types
    class func getAllergyTypesUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let allergyTypeKey = "/patient/allergies/fetchAll"
        let allergyTypeUrl = baseUrl.appending(allergyTypeKey)
        return allergyTypeUrl
    }
    // MARK: - Get MedicationURL
    class func getMedicationUrl(patiantId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let medicationKey = "/patient/medications/\(patiantId)/fetchAll"
        let medicationUrl = baseUrl.appending(medicationKey)
        return medicationUrl
    }
    // MARK: - Get AddMedicationURL
    class func getAddMedicationUrl(patiantId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let addMedicationKey = "/patient/medication/\(patiantId)/add"
        let addMedicationUrl = baseUrl.appending(addMedicationKey)
        return addMedicationUrl
    }
    // MARK: - Get MedicalConditionalURL
    
    ////patient/medicalCondition/fetchAll
    class func getMedicalConditionalURL(patiantId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let medicalKey = "/patient/medicalCondition/\(patiantId)/fetchAll"
        let medicalKeyUrl = baseUrl.appending(medicalKey)
        return medicalKeyUrl
    }
    // MARK: - All MedicalConditionalURL
    class func getAllMedicalConditionalURL() -> String
    {
        let baseUrl = self.getBaseURL()
        let allMedicalKey = "/patient/medicalCondition/fetchAll"
        let allMedicalKeyUrl = baseUrl.appending(allMedicalKey)
        return allMedicalKeyUrl
    }
    // MARK: - Get AddMedicalConditionalURL
    class func getAddMedicalConditionalURL(patiantId : Int) -> String
    {
        let baseUrl = self.getBaseURL()
        let addMedicalKey = "/patient/\(patiantId)/medicalCondition/add"
        let addMedicalKeyUrl = baseUrl.appending(addMedicalKey)
        return addMedicalKeyUrl
    }
    // MARK: - Get deleteMedicalConditionalURL
    class func getDeleteMedicalConditionalURL(patiantId : Int, medicalCondtionID : Int, date: String) -> String
    {
        let baseUrl = self.getBaseURL()
        let deleteMedicalKey = "/patient/\(patiantId)/medicalCondition/\(medicalCondtionID)/delete?date=".appending(date)
        let deleteMedicalKeyUrl = baseUrl.appending(deleteMedicalKey)
        return deleteMedicalKeyUrl
    }
    // MARK: -  MedicationDeleteURL
    class func getMedicationDeleteUrl(patiantId : Int, madicationid : Int, date : String) -> String
    {
        let baseUrl = self.getBaseURL()
        let deletemedicationKey = "/patient/\(patiantId)/medication/\(madicationid)/delete?date=".appending(date)
        let deletemedicationUrl = baseUrl.appending(deletemedicationKey)
        return deletemedicationUrl
    }
    // MARK: -  AllergyDeleteURL
    class func getAllergyDeleteUrl(patiantId : Int, allergyId : Int) -> String
    {
        //patient/$id<.+>/patientMedicalAllergy/$aid<.+>/delete
        
        let baseUrl = self.getBaseURL()
        let deleteAllergyKey = "/patient/\(patiantId)/patientMedicalAllergy/\(allergyId)/delete"
        //delete?date=".appending(date)
        let deleteAllergyUrl = baseUrl.appending(deleteAllergyKey)
        return deleteAllergyUrl
    }
     // MARK: -  fetchProfessionalsByCriteriaURL
    class func getProfessionByCritiaUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let professionalsByCriteriaKey = "/professional/fetchProfessionalsByCriteria"
        let professionalsByCriteriaUrl = baseUrl.appending(professionalsByCriteriaKey)
        return professionalsByCriteriaUrl
    }
    // MARK: -  AllergyDeleteURL
    class func getCreateAppointmnetUrl() -> String
    {
        let baseUrl = self.getBaseURL()
        let createAppointmentKey = "/patient/appointment/bookAppointment"
        let createAppointmentUrl = baseUrl.appending(createAppointmentKey)
        return createAppointmentUrl
    }
}
////http://wow-healthcare.com:9000/abc // url List

