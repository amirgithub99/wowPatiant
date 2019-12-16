//  ProfessionDetailControler.swift
//  Wow Patient
//
//  Created by Amir on 19/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//
import UIKit
enum SelecteAppointmentType : Int {
    case Audio = 0
    case Video
    case Inperson
}
class ProfessionDetailControler: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var specialistLbl : UILabel!
    @IBOutlet weak var ratingtLbl : UILabel!
    @IBOutlet weak var doctorNameLbl : UILabel!
    @IBOutlet weak var doctorPhoneLbl : UILabel!
    @IBOutlet weak var doctorEmailLbl : UILabel!
    @IBOutlet weak var aboutDoctorLbl : UILabel!
     @IBOutlet weak var professionalImage : UIImageView!
    
    @IBOutlet weak var doctorAddressTxtView : UITextView!
    @IBOutlet weak var inPersonBtn : UIButton!
    @IBOutlet weak var videoBtn : UIButton!
    @IBOutlet weak var audioBtn : UIButton!
    var isAppointmentTypeSelected = Bool()
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerImageView: UIImageView!


    
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var videoBtnLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var audioBtnLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var videoBtnWidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var audioBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTxtView : UITextView!
    var appointmentType : SelecteAppointmentType!
    public var professionalObj = Professionalinfo()
    var doctorProfession_ID = Int()
    
    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.showProfessionDetailInfo(professionalInfo: self.professionalObj)
        

        
        
        DispatchQueue.main.async {
            var scrollViewHeight = CGFloat()
            if self.scrollView.frame.size.height > self.scrollView.frame.size.width
            {
                scrollViewHeight =  self.scrollView.frame.size.height
            }
            else
            {
                scrollViewHeight =  self.scrollView.frame.size.width
            }
            self.contentViewHeightConst.constant = scrollViewHeight
            self.contentView.layoutIfNeeded()
            //self.contentView.backgroundColor = UIColor.red
            self.centerView.layoutIfNeeded()
            self.centerImageView.layoutIfNeeded()
        }
        
        
        
        
        
        
        
//        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.doctorAddressTxtView.delegate = self
        self.noteTxtView.delegate = self
        self.doctorAddressTxtView.endEditing(true)
        self.noteTxtView.endEditing(true)
        

        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
//        UIView.animate(withDuration: 0.5)
//        {
        
        var scrollViewHeight = CGFloat()
        if self.scrollView.frame.size.height > self.scrollView.frame.size.width
        {
            scrollViewHeight =  self.scrollView.frame.size.height
        }
        else
        {
            scrollViewHeight =  self.scrollView.frame.size.width
        }
        self.contentViewHeightConst.constant = scrollViewHeight
        self.contentView.layoutIfNeeded()
        //self.contentView.backgroundColor = UIColor.red
        self.centerView.layoutIfNeeded()
        self.centerImageView.layoutIfNeeded()
        
       // }
        
        
        // Do any additional setup after loading the view.
        
    }
    // MARK:- Show Profession Info inView
    func showProfessionDetailInfo(professionalInfo : Professionalinfo)
    {
      let professionalInfosObj = professionalInfo
        let  firstNameStr = professionalInfosObj.firstName
        let  middleNameStr = professionalInfosObj.middleName
        let  lastNameStr = professionalInfosObj.lastName
        var  doctorNameStr = firstNameStr?.appending(" ")
        doctorNameStr = doctorNameStr?.appending(middleNameStr!)
        doctorNameStr = doctorNameStr?.appending(" ")
        doctorNameStr = doctorNameStr?.appending(lastNameStr!)
        
        let ratingStr = professionalInfosObj.rating
        self.ratingtLbl.text = ratingStr
        let emailStr = professionalInfosObj.email
        let specialityNameStr = professionalInfosObj.specialityName
        self.specialistLbl.text = specialityNameStr
        let noteStr = professionalInfosObj.notes
        let phoneOfficeStr = professionalInfosObj.phoneMobile
        let isAudioAppointment = professionalInfosObj.audio
        let isVideoAppointment = professionalInfosObj.video
        let isPersonAppointment = professionalInfosObj.inPerson
        
        var doctorClinicAddress : String?
        
        let professionImageStr = professionalInfosObj.logoPath
        let imageUrl = URL(string: professionImageStr!)
        
        //let professionalData = try? Data(ContentsOf: imageUrl!)
        if imageUrl != nil
        {
           self.professionalImage.sd_setImage(with: imageUrl, placeholderImage: nil, options: [.continueInBackground], completed: nil)
        }
        else
        {
            self.professionalImage.image = UIImage(named : "doctorImg")
        }
        if isAudioAppointment != nil && isAudioAppointment == false
        {
            self.audioBtnWidthConstraint.constant = 0
            self.audioBtnLeadingContraint.constant = 0
        }
        if isVideoAppointment != nil && isVideoAppointment == false
        {
            self.videoBtnLeadingContraint.constant = 0
            self.videoBtnWidthConstaint.constant = 0
        }
        if isPersonAppointment !=  nil && isPersonAppointment == false
        {
               self.inPersonBtn.isHidden = true
        }
        
        let professionalAddressesArr = professionalInfo.professionAddresss.professionalAdressArr
        
        for var i in 0..<professionalAddressesArr.count {
            let professionalAddresses = professionalAddressesArr[i]
            if professionalAddresses.addressType == 3
            {
                let addressline1Str = professionalAddresses.addressLine1
                let addressline2Str  = professionalAddresses.addressLine2
                let countryName = professionalAddresses.countryName
                let stateName = professionalAddresses.stateName
                let zipCode = professionalAddresses.zipCode
                var fullAddress = addressline1Str?.appending(" ")
                fullAddress = fullAddress?.appending(addressline2Str!)
                fullAddress = fullAddress?.appending(" ")
                fullAddress = fullAddress?.appending(countryName!)
                fullAddress = fullAddress?.appending(" ")
                fullAddress = fullAddress?.appending(stateName!)
                fullAddress = fullAddress?.appending(" ")
                fullAddress = fullAddress?.appending(zipCode!)
                doctorClinicAddress = fullAddress
                break
            }
            i += 1
        }
        self.doctorEmailLbl.text = emailStr
        self.doctorNameLbl.text = doctorNameStr
        var aboutStr = "About "
        aboutStr = aboutStr.appending(doctorNameStr!)
        aboutStr = aboutStr.appending(":")
        self.aboutDoctorLbl.text = aboutStr
        self.nameLbl.text = doctorNameStr
         self.doctorAddressTxtView.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 3)
        self.doctorAddressTxtView.text = doctorClinicAddress
        self.noteTxtView.text = noteStr
        self.doctorPhoneLbl.text = phoneOfficeStr
    }
    // MARK:- Show InPersionIsSelected
    @IBAction func showInPersionIsSelectedd(_ sender: Any)
    {
        if self.professionalObj.video == true
        {
            self.videoBtn.setImage(UIImage(named: "video"), for: .normal)
        }
        
        if self.professionalObj.audio == true
        {
            self.audioBtn.setImage(UIImage(named: "audio"), for: .normal)
        }
        self.inPersonBtn.setImage(UIImage(named: "inPersonSelected"), for: .normal)
         self.appointmentType = SelecteAppointmentType.Inperson
        self.isAppointmentTypeSelected = true
    }
     // MARK:- Show AudioIsSelected
    @IBAction func showAudioIsSelectedd(_ sender: Any)
    {
        if self.professionalObj.inPerson == true
        {
              self.inPersonBtn.setImage(UIImage(named: "InPerson"), for: .normal)
        }
        if self.professionalObj.video == true
        {
          self.videoBtn.setImage(UIImage(named: "video"), for: .normal)
        }
        self.audioBtn.setImage(UIImage(named: "audioSelected"), for: .normal)
        self.appointmentType = SelecteAppointmentType.Audio
        self.isAppointmentTypeSelected = true
    }
    // MARK:- Show VideoIsSelected
    @IBAction func showVideoIsSelectedd(_ sender: Any)
    {
        if self.professionalObj.inPerson == true
        {
            self.inPersonBtn.setImage(UIImage(named: "InPerson"), for: .normal)
        }
        if self.professionalObj.audio == true
        {
            self.audioBtn.setImage(UIImage(named: "audio"), for: .normal)
        }
        self.videoBtn.setImage(UIImage(named: "videoSelected"), for: .normal)
        self.appointmentType = SelecteAppointmentType.Video
        self.isAppointmentTypeSelected = true
    }
     // MARK:- Back To SearchDoctorController
    @IBAction func goBackToSearchDoctorController(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    // MARK:- Back To CreateAppointmentViewController
    @IBAction func goToCreateAppointmentViewController(_ sender: Any)
    {
        if self.isAppointmentTypeSelected == false
        {
            self.showAlertView(titlee: "Select Appointment Type", messagee: "")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createAppointmentInfo.video = true
        let firstName = self.professionalObj.firstName
        let middleName = self.professionalObj.middleName
        let lastName = self.professionalObj.lastName
        var fullName = firstName?.appending(" ")
        fullName = fullName?.appending(middleName!)
        fullName = fullName?.appending(lastName!)
        appDelegate.createAppointmentInfo.professionalName = fullName
        appDelegate.createAppointmentInfo.professionalSpeciality = self.professionalObj.specialityName
        appDelegate.createAppointmentInfo.professionalInfoo.professionalID = self.professionalObj.professionalID

       
        var selecteAppointmentType : SelecteAppointmentType
        selecteAppointmentType = SelecteAppointmentType(rawValue: appointmentType!.rawValue)!
        
        switch selecteAppointmentType {
        case .Audio:
            
            appDelegate.createAppointmentInfo.inPerson = false
            appDelegate.createAppointmentInfo.video = false
            appDelegate.createAppointmentInfo.audio = true
            break
        case .Video:
            appDelegate.createAppointmentInfo.inPerson = false
            appDelegate.createAppointmentInfo.video = true
            appDelegate.createAppointmentInfo.audio = false
            break
        case .Inperson:
            appDelegate.createAppointmentInfo.inPerson = true
            appDelegate.createAppointmentInfo.video = false
            appDelegate.createAppointmentInfo.audio = false
            break
        }
        let goToCreateAppointmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateAppointmentControler") as! CreateAppointmentControler
        self.navigationController?.pushViewController(goToCreateAppointmentViewController, animated: true)
    }
    // MARK: - Show Alert Controller
    func showAlertView(titlee : NSString, messagee : NSString)
    {
        let alertController = UIAlertController(title: titlee as String, message: messagee as String, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            // male is Selected
        }))
        self.present(alertController, animated: true, completion: nil)
    } // end function
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        self.view.endEditing(true)
        textView.resignFirstResponder()
        return false
    }
    
    
}
